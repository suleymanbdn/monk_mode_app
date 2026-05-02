import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_formatting.dart';
import '../../../widgets/primary_button.dart';
import '../models/focus_room_models.dart';
import '../focus_room_navigation.dart';
import '../focus_room_runtime.dart';
import '../state/focus_room_controller.dart';
import '../widgets/fr_card.dart';
import '../widgets/fr_participant_tile.dart';
import '../widgets/fr_cross_device_warning.dart';
import '../widgets/fr_room_code_block.dart';
import '../widgets/fr_section_header.dart';
import 'shared_session_screen.dart';

class RoomLobbyScreen extends StatefulWidget {
  const RoomLobbyScreen({super.key, required this.controller});

  final FocusRoomController controller;

  @override
  State<RoomLobbyScreen> createState() => _RoomLobbyScreenState();
}

class _RoomLobbyScreenState extends State<RoomLobbyScreen> {
  bool _pushedToSession = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context);
        final room = controller.room;

        if (room != null &&
            room.phase == FocusRoomPhase.running &&
            !controller.isHost) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _pushedToSession) return;
            if (widget.controller.room?.phase != FocusRoomPhase.running) return;
            _pushedToSession = true;
            Navigator.of(context).pushReplacement(
              focusRoomFadeRoute(
                SharedSessionScreen(controller: widget.controller),
              ),
            );
          });
        }
        if (room == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.ftLobbyTitle),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.meeting_room_outlined,
                      size: 48,
                      color: AppColors.onSurfaceSubtle,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.ftLobbyEmptyTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.ftLobbyEmptyBody,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: l10n.ftBackToHub,
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final viewerIsHost = controller.isHost;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.ftLobbyTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () async {
                await controller.leaveLobby();
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              children: [
                if (room.name.isNotEmpty) ...[
                  Text(
                    room.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                ] else ...[
                  Text(
                    l10n.ftDefaultRoomTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  '${l10n.formatSessionMinutes(room.durationMinutes)} ${l10n.ftSessionBlockSuffix}'
                  '${l10n.ftLobbyMetaMiddle}'
                  '${l10n.ftLobbyHereCount(room.participants.length)}'
                  '${l10n.ftLobbyMetaMiddle}'
                  '${_phaseLabel(l10n, room.phase)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  viewerIsHost
                      ? (focusRoomCloudSyncEnabled
                            ? l10n.ftLobbyShareOnline
                            : l10n.ftLobbyShareOffline)
                      : l10n.ftLobbyGuestWait,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                ),
                const SizedBox(height: 24),
                FrRoomCodeBlock(code: room.code),
                if (viewerIsHost) ...[
                  const SizedBox(height: 16),
                  const FrCrossDeviceWarning(
                    variant: FrCrossDeviceWarningVariant.lobbyHost,
                  ),
                ],
                const SizedBox(height: 28),
                FrSectionHeader(l10n.ftInThisRoom),
                const SizedBox(height: 12),
                FrCard(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Column(
                    children: [
                      for (final p in room.participants)
                        FrParticipantTile(
                          participant: p,
                          localUserId: controller.localUserId,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (viewerIsHost) ...[
                  PrimaryButton(
                    label: l10n.ftStartFocusTimer,
                    icon: Icons.play_arrow_rounded,
                    onPressed: () async {
                      await controller.startSharedSession();
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        focusRoomFadeRoute(
                          SharedSessionScreen(controller: controller),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  PrimaryButton(
                    label: _guestReadyLabel(l10n, room),
                    icon: Icons.check_rounded,
                    onPressed: () => controller.toggleReady(),
                  ),
                ],
                const SizedBox(height: 12),
                PrimaryButton(
                  label: l10n.ftLeaveLobby,
                  outlined: true,
                  onPressed: () async {
                    await controller.leaveLobby();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  String _guestReadyLabel(AppLocalizations l10n, FocusRoom room) {
    FocusParticipant? self;
    for (final p in room.participants) {
      if (p.id == widget.controller.localUserId) {
        self = p;
        break;
      }
    }
    if (self?.presence == ParticipantPresence.ready) {
      return l10n.ftSetToWaiting;
    }
    return l10n.ftImReady;
  }

  String _phaseLabel(AppLocalizations l10n, FocusRoomPhase phase) {
    return switch (phase) {
      FocusRoomPhase.lobby => l10n.ftPhaseLobby,
      FocusRoomPhase.running => l10n.ftPhaseRunning,
      FocusRoomPhase.ended => l10n.ftPhaseEnded,
    };
  }
}
