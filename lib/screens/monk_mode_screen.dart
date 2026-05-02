import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_formatting.dart';
import '../models/app_stats.dart';
import '../services/storage_service.dart';
import '../utils/time_utils.dart';
import '../widgets/primary_button.dart';

// ── Timer state ───────────────────────────────────────────────────────────────

enum TimerStatus {
  idle, // Waiting to start. Duration can be changed.
  running, // Counting down.
  paused, // Ticking stopped. Can resume or reset.
  done, // Session finished — success dialog is open.
}

// ── Dev mode ──────────────────────────────────────────────────────────────────
// Flip to false before releasing to production.
const bool kDevMode = false;

// ── Durations ─────────────────────────────────────────────────────────────────
// Production chip lengths (minutes) come from [StorageService.loadDurationPresets].

/// Short durations (in **seconds**) shown only when [kDevMode] is true.
const _devDurations = [10, 30, 60]; // seconds — test sessions

// ── Screen ────────────────────────────────────────────────────────────────────

class MonkModeScreen extends StatefulWidget {
  const MonkModeScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<MonkModeScreen> createState() => _MonkModeScreenState();
}

class _MonkModeScreenState extends State<MonkModeScreen>
    with WidgetsBindingObserver {
  // ── State ──────────────────────────────────────────────────────────────────
  late List<int> _presetMinutes;
  late int _selectedDuration; // seconds
  TimerStatus _status = TimerStatus.idle;
  late int _remainingSeconds;
  Timer? _ticker;

  /// True when [TimerStatus.paused] was caused by leaving the app (not the PAUSE button).
  bool _pausedDueToBackground = false;

  // ── Computed helpers ───────────────────────────────────────────────────────
  int get _totalSeconds => _selectedDuration;
  // 1.0 = full ring (session just started), 0.0 = empty ring (session done).
  double get _progress => _remainingSeconds / _totalSeconds;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _presetMinutes = widget.storage.loadDurationPresets();
    _selectedDuration = _presetMinutes.first * 60;
    _remainingSeconds = _selectedDuration;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    unawaited(WakelockPlus.disable());
    super.dispose();
  }

  /// While the countdown is running, keep the display awake (industry standard for
  /// focus timers) so the OS auto-lock does not fire [AppLifecycleState.paused] and
  /// pause the session. Leaving the app / task switch still pauses.
  void _syncWakeLockWithTimerState() {
    if (_status == TimerStatus.running) {
      unawaited(WakelockPlus.enable());
    } else {
      unawaited(WakelockPlus.disable());
    }
  }

  /// Focus time must not accrue while the user is in another app. When the app
  /// is no longer in the foreground, treat that like a pause.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_pausedDueToBackground &&
            _status == TimerStatus.paused &&
            mounted) {
          _pausedDueToBackground = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            final msg = AppLocalizations.of(context).monkBgPauseSnackbar;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                duration: const Duration(seconds: 4),
              ),
            );
          });
        }
        return;
      // Skip [inactive]: notification shade / quick settings use it without leaving the app.
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        if (_status == TimerStatus.running) {
          _pausedDueToBackground = true;
          _onPause();
        }
        return;
      case AppLifecycleState.inactive:
        return;
      case AppLifecycleState.detached:
        return;
    }
  }

  // ── Timer logic ────────────────────────────────────────────────────────────

  void _onStart() {
    _ticker?.cancel();
    HapticFeedback.mediumImpact();
    setState(() => _status = TimerStatus.running);
    _syncWakeLockWithTimerState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      // Defensive guard: dispose() cancels the ticker, but this makes
      // the intent explicit and handles any unexpected ordering.
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        _onComplete();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _onPause() {
    _ticker?.cancel();
    HapticFeedback.lightImpact();
    setState(() => _status = TimerStatus.paused);
    _syncWakeLockWithTimerState();
  }

  void _onResume() {
    _pausedDueToBackground = false;
    _onStart();
  }

  void _onReset() {
    _ticker?.cancel();
    _pausedDueToBackground = false;
    setState(() {
      _status = TimerStatus.idle;
      _remainingSeconds = _totalSeconds;
    });
    _syncWakeLockWithTimerState();
  }

  Future<void> _onComplete() async {
    _ticker?.cancel();
    HapticFeedback.heavyImpact();
    setState(() {
      _remainingSeconds = 0;
      _status = TimerStatus.done;
    });
    _syncWakeLockWithTimerState();

    // Save the session: increases focus minutes, marks today, updates streak.
    final updated = await widget.storage.updateAfterCompletedSession(
      _selectedDuration ~/ 60,
    );

    if (!context.mounted) return;

    // Capture context synchronously before the next async gap.
    final ctx = context;

    // Show success dialog, then return to HomeScreen when it closes.
    await _showSuccessDialog(ctx, updated, _selectedDuration ~/ 60);

    if (ctx.mounted) Navigator.pop(ctx);
  }

  void _onSelectDuration(int seconds) {
    if (_status != TimerStatus.idle) return;
    setState(() {
      _selectedDuration = seconds;
      _remainingSeconds = seconds;
    });
  }

  // ── Share capture ──────────────────────────────────────────────────────────

  Future<void> _captureAndShare(GlobalKey key) async {
    try {
      final subject = AppLocalizations.of(context).monkShareSubject;
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'image/png',
              name: 'monk_mode_session.png',
            ),
          ],
          subject: subject,
        ),
      );
    } catch (_) {
      // Sharing is a bonus feature — fail silently rather than crash.
    }
  }

  // ── Success dialog ─────────────────────────────────────────────────────────

  Future<void> _showSuccessDialog(
    BuildContext context,
    AppStats stats,
    int durationMinutes,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final shareCardKey = GlobalKey();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.monkCompleteTitle,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.monkCompleteSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              RepaintBoundary(
                key: shareCardKey,
                child: _ShareCard(
                  l10n: l10n,
                  durationMinutes: durationMinutes,
                  streak: stats.effectiveStreak,
                  dopamineScore: stats.dopamineScore,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: l10n.monkShareResult,
                icon: Icons.share_rounded,
                onPressed: () => _captureAndShare(shareCardKey),
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                label: l10n.monkBackHome,
                outlined: true,
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Back navigation ────────────────────────────────────────────────────────

  Future<bool> _onWillPop() async {
    if (_status != TimerStatus.running) return true;

    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(l10n.monkLeaveTitle),
        content: Text(l10n.monkLeaveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.monkKeepGoing),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.monkLeaveAction,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: _status != TimerStatus.running,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final canLeave = await _onWillPop();
          if (canLeave && context.mounted) {
            _ticker?.cancel();
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.monkAppBarTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () async {
              final canLeave = await _onWillPop();
              if (canLeave && context.mounted) {
                _ticker?.cancel();
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 32),
                _TimerRing(
                  remainingSeconds: _remainingSeconds,
                  progress: _progress,
                  status: _status,
                ),
                if (_status == TimerStatus.running) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      l10n.monkStayAwakeHint,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],

                const Spacer(),

                if (_status == TimerStatus.idle) ...[
                  _DurationPicker(
                    presetMinutes: _presetMinutes,
                    selectedDuration: _selectedDuration,
                    onSelect: _onSelectDuration,
                  ),
                  const SizedBox(height: 28),
                ],
                _TimerControls(
                  status: _status,
                  onStart: _onStart,
                  onPause: _onPause,
                  onResume: _onResume,
                  onReset: _onReset,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Timer Ring ────────────────────────────────────────────────────────────────

class _TimerRing extends StatelessWidget {
  const _TimerRing({
    required this.remainingSeconds,
    required this.progress,
    required this.status,
  });

  final int remainingSeconds;
  final double progress;
  final TimerStatus status;

  String _statusLabel(AppLocalizations l10n) => switch (status) {
    TimerStatus.idle => l10n.monkReady,
    TimerStatus.running => l10n.monkFocus,
    TimerStatus.paused => l10n.monkPaused,
    TimerStatus.done => l10n.monkDone,
  };

  Color get _ringColor => switch (status) {
    TimerStatus.paused => AppColors.onSurfaceVariant,
    _ => AppColors.primary,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // TweenAnimationBuilder interpolates between the current ring value and
    // the new target every time `progress` changes (once per second).
    // duration: 900 ms keeps the ring slightly ahead of the next tick so the
    // motion looks continuous rather than a series of discrete jumps.
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: progress),
      duration: const Duration(milliseconds: 900),
      curve: Curves.linear,
      builder: (_, animatedProgress, __) {
        return CircularPercentIndicator(
          radius: 135,
          lineWidth: 8,
          percent: animatedProgress.clamp(0.0, 1.0),
          animation: false,
          backgroundColor: AppColors.surfaceContainerHighest,
          progressColor: _ringColor,
          circularStrokeCap: CircularStrokeCap.round,
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                TimeUtils.formatSeconds(remainingSeconds),
                style: theme.textTheme.displayLarge?.copyWith(
                  color: status == TimerStatus.paused
                      ? AppColors.onSurfaceVariant
                      : AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(_statusLabel(l10n), style: theme.textTheme.labelMedium),
            ],
          ),
        );
      },
    );
  }
}

// ── Duration Picker ───────────────────────────────────────────────────────────

class _DurationPicker extends StatelessWidget {
  const _DurationPicker({
    required this.presetMinutes,
    required this.selectedDuration, // seconds
    required this.onSelect, // callback receives seconds
  });

  final List<int> presetMinutes;
  final int selectedDuration;
  final ValueChanged<int> onSelect;

  static String _devLabel(int seconds) =>
      seconds < 60 ? '${seconds}s' : '${seconds ~/ 60}m';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labelStyle = Theme.of(context).textTheme.labelMedium;

    return Column(
      children: [
        // ── Production durations ───────────────────────────────────────────
        Text(l10n.monkSelectDuration, style: labelStyle),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: presetMinutes.map((minutes) {
            final seconds = minutes * 60;
            return _DurationChip(
              label: l10n.formatSessionMinutes(minutes),
              isSelected: seconds == selectedDuration,
              onTap: () => onSelect(seconds),
            );
          }).toList(),
        ),

        // ── Dev test durations (kDevMode only) ────────────────────────────
        if (kDevMode) ...[
          const SizedBox(height: 18),
          Text(
            l10n.monkTestMode,
            style: labelStyle?.copyWith(color: AppColors.tertiary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _devDurations.map((seconds) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _DurationChip(
                  label: _devLabel(seconds),
                  isSelected: seconds == selectedDuration,
                  onTap: () => onSelect(seconds),
                  isDev: true,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDev = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  /// When true, the chip uses the tertiary (teal) accent instead of primary.
  final bool isDev;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDev ? AppColors.tertiary : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: isSelected
                ? AppColors.onPrimary
                : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Controls ──────────────────────────────────────────────────────────────────

class _TimerControls extends StatelessWidget {
  const _TimerControls({
    required this.status,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
  });

  final TimerStatus status;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Hide controls while the success dialog is open.
    if (status == TimerStatus.done) return const SizedBox.shrink();

    // Idle: single full-width start button.
    if (status == TimerStatus.idle) {
      return PrimaryButton(
        label: l10n.monkStartSession,
        icon: Icons.play_arrow_rounded,
        onPressed: onStart,
      );
    }

    // Running / paused: reset on the left, pause/resume on the right.
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            label: l10n.monkReset,
            outlined: true,
            onPressed: onReset,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: PrimaryButton(
            label: status == TimerStatus.running
                ? l10n.monkPause
                : l10n.monkResume,
            icon: status == TimerStatus.running
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            onPressed: status == TimerStatus.running ? onPause : onResume,
          ),
        ),
      ],
    );
  }
}

// ── Shareable result card ─────────────────────────────────────────────────────
//
// Rendered as the capture target inside a RepaintBoundary so it can be
// exported to PNG and passed to the native share sheet.

class _ShareCard extends StatelessWidget {
  const _ShareCard({
    required this.l10n,
    required this.durationMinutes,
    required this.streak,
    required this.dopamineScore,
  });

  final AppLocalizations l10n;
  final int durationMinutes;
  final int streak;
  final int dopamineScore;

  @override
  Widget build(BuildContext context) {
    final durationLabel = l10n.formatSessionMinutes(durationMinutes);
    final streakLabel = streak > 0
        ? (streak == 1
              ? l10n.monkShareStreakOne
              : l10n.monkShareStreakMany(streak))
        : l10n.monkShareStreakNew;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDim, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                l10n.appTitle,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.self_improvement_rounded,
                color: AppColors.primaryDim,
                size: 15,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _CardStat(
                value: durationLabel,
                label: l10n.monkShareStatDuration,
              ),
              const SizedBox(width: 24),
              _CardStat(value: streakLabel, label: l10n.monkShareStatStreak),
              const SizedBox(width: 24),
              _CardStat(
                value: '$dopamineScore',
                label: l10n.monkShareStatScore,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.outline),
          const SizedBox(height: 14),
          Text(
            l10n.monkShareTagline,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.2,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card stat column ──────────────────────────────────────────────────────────

class _CardStat extends StatelessWidget {
  const _CardStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceSubtle,
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }
}
