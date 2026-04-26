import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_formatting.dart';
import '../../../utils/time_utils.dart';
import '../models/focus_room_models.dart';
import '../focus_room_runtime.dart';
import '../state/focus_room_controller.dart';
import '../widgets/fr_card.dart';
import '../widgets/fr_group_timer_ring.dart';
import '../widgets/fr_leave_session_dialog.dart';
import '../widgets/fr_section_header.dart';
import 'session_summary_screen.dart';

class SharedSessionScreen extends StatefulWidget {
  const SharedSessionScreen({super.key, required this.controller});

  final FocusRoomController controller;

  @override
  State<SharedSessionScreen> createState() => _SharedSessionScreenState();
}

class _SharedSessionScreenState extends State<SharedSessionScreen>
    with WidgetsBindingObserver {
  bool _navigatedToSummary = false;
  bool _sessionTickerPausedForBackground = false;
  bool _sessionWakeLockHeld = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_onController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncSessionScreenWakeLock();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_onController);
    unawaited(WakelockPlus.disable());
    _sessionWakeLockHeld = false;
    super.dispose();
  }

  /// Same policy as [MonkModeScreen]: stay awake while the shared session is in
  /// [FocusRoomPhase.running] so display auto-lock does not pause the local ticker.
  void _syncSessionScreenWakeLock() {
    if (!mounted || _navigatedToSummary) {
      if (_sessionWakeLockHeld) {
        _sessionWakeLockHeld = false;
        unawaited(WakelockPlus.disable());
      }
      return;
    }
    final want = widget.controller.room?.phase == FocusRoomPhase.running;
    if (want == _sessionWakeLockHeld) return;
    _sessionWakeLockHeld = want;
    if (want) {
      unawaited(WakelockPlus.enable());
    } else {
      unawaited(WakelockPlus.disable());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_navigatedToSummary) return;
    final c = widget.controller;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (c.room?.phase == FocusRoomPhase.running) {
        c.pauseSessionTickerForBackground();
        _sessionTickerPausedForBackground = true;
      }
      return;
    }
    if (state == AppLifecycleState.resumed &&
        _sessionTickerPausedForBackground) {
      _sessionTickerPausedForBackground = false;
      c.resumeSessionTickerAfterForeground();
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final msg = AppLocalizations.of(context).ftBgSessionPausedSnackbar;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), duration: const Duration(seconds: 4)),
          );
        });
      }
    }
  }

  void _onController() {
    if (!mounted) return;
    if (!_navigatedToSummary) {
      _syncSessionScreenWakeLock();
    }
    if (_navigatedToSummary || !mounted) return;
    final c = widget.controller;
    final room = c.room;
    if (room == null) return;
    if (room.phase != FocusRoomPhase.ended) return;
    if ((c.sessionRemainingSeconds ?? -1) != 0) return;

    FocusParticipant? self;
    for (final p in room.participants) {
      if (p.id == c.localUserId) self = p;
    }
    if (self?.presence == ParticipantPresence.left) return;

    _navigatedToSummary = true;
    _syncSessionScreenWakeLock();
    final summary = c.buildNaturalCompleteSummary();
    c.clearRoom();
    unawaited(_pushSummary(summary));
  }

  Future<void> _pushSummary(FocusSessionSummary summary) async {
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SessionSummaryScreen(summary: summary)),
    );
  }

  Future<void> _confirmAndLeaveEarly() async {
    if (_navigatedToSummary) return;
    final leave = await showFocusRoomLeaveSessionDialog(context);
    if (!mounted || !leave) return;
    await _leaveEarlyAndGoSummary();
  }

  Future<void> _leaveEarlyAndGoSummary() async {
    if (_navigatedToSummary) return;
    _navigatedToSummary = true;
    _syncSessionScreenWakeLock();
    final summary = await widget.controller.leaveSessionEarly();
    if (!mounted) return;
    widget.controller.clearRoom();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SessionSummaryScreen(summary: summary)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final c = widget.controller;
        final room = c.room;
        final total = room != null ? room.durationMinutes * 60 : 0;
        final remaining = c.sessionRemainingSeconds ?? 0;
        final progress = total > 0 ? remaining / total : 0.0;
        final label = TimeUtils.formatSeconds(remaining.clamp(0, total));
        final lengthLabel = room != null
            ? '${l10n.formatSessionMinutes(room.durationMinutes)} ${l10n.ftSessionBlockSuffix}'
            : null;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            unawaited(_confirmAndLeaveEarly());
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.ftInSessionTitle),
              automaticallyImplyLeading: false,
              actions: [
                TextButton(
                  onPressed: _confirmAndLeaveEarly,
                  child: Text(
                    l10n.ftEndSessionAction,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            room == null || room.name.isEmpty
                                ? l10n.ftSharedFocusDefaultName
                                : room.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.ftInRoomCount(room?.participants.length ?? 0),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          _TimerRingEntrance(
                            child: FrGroupTimerRing(
                              progress: progress,
                              centerLabel: label,
                              subLabel: l10n.ftTimerFocusLabel,
                              sessionLengthLabel: lengthLabel,
                            ),
                          ),
                          if (room?.phase == FocusRoomPhase.running) ...[
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                l10n.ftStayAwakeHint,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 28),
                          FrSectionHeader(l10n.ftTogetherSection),
                          const SizedBox(height: 12),
                          FrCard(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.sync_rounded,
                                  color: AppColors.tertiary,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    room?.phase == FocusRoomPhase.running
                                        ? (focusRoomCloudSyncEnabled
                                              ? l10n.ftSessionSyncOnline
                                              : l10n.ftSessionSyncOffline)
                                        : l10n.ftSessionUpdating,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// One-time fade + slide when entering the session (avoids restarting on timer ticks).
class _TimerRingEntrance extends StatefulWidget {
  const _TimerRingEntrance({required this.child});

  final Widget child;

  @override
  State<_TimerRingEntrance> createState() => _TimerRingEntranceState();
}

class _TimerRingEntranceState extends State<_TimerRingEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: AnimatedBuilder(
        animation: curved,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 16 * (1 - curved.value)),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
