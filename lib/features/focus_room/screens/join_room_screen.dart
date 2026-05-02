import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../data/focus_room_repository.dart';
import '../../../widgets/primary_button.dart';
import '../focus_room_navigation.dart';
import '../state/focus_room_controller.dart';
import '../widgets/fr_card.dart';
import '../focus_room_runtime.dart';
import '../widgets/fr_cross_device_warning.dart';
import '../widgets/fr_focus_states.dart';
import '../widgets/fr_section_header.dart';
import 'room_lobby_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key, required this.controller});

  final FocusRoomController controller;

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _codeController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final raw = _codeController.text
        .replaceAll(RegExp(r'\s'), '')
        .toUpperCase();
    if (raw.length != 8) {
      final msg = AppLocalizations.of(context).ftJoinMinChars;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }

    if (_busy) return;
    setState(() => _busy = true);
    try {
      final result = await widget.controller.joinByCode(raw);
      if (!mounted) return;
      if (!result.isSuccess) {
        final l10n = AppLocalizations.of(context);
        final kind = result.failure;
        if (kind == null) return;
        final String message = switch (kind) {
          JoinRoomFailureKind.notFound =>
            focusRoomCloudSyncEnabled
                ? l10n.joinRoomNotFoundCloud
                : l10n.joinRoomNotFoundLocal,
          JoinRoomFailureKind.networkUnavailable => l10n.joinRoomNetworkError,
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        focusRoomFadeRoute(RoomLobbyScreen(controller: widget.controller)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final code = _codeController.text
        .replaceAll(RegExp(r'\s'), '')
        .toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ftJoinAppBar),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: _busy ? null : () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            children: [
              Text(
                l10n.ftJoinEnterCode,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.ftJoinCodeHelp,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              const FrCrossDeviceWarning(
                variant: FrCrossDeviceWarningVariant.joinScreen,
              ),
              const SizedBox(height: 20),
              FrSectionHeader(l10n.ftJoinCodeSection),
              const SizedBox(height: 12),
              FrCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _codeController,
                  enabled: !_busy,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _join(),
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.go,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    letterSpacing: 6,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  cursorColor: AppColors.primary,
                  decoration: const InputDecoration(
                    hintText: '••••••••',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppColors.onSurfaceSubtle,
                      letterSpacing: 6,
                    ),
                  ),
                  maxLength: 12,
                  buildCounter:
                      (
                        _, {
                        required currentLength,
                        required isFocused,
                        maxLength,
                      }) => null,
                ),
              ),
              if (code.isNotEmpty && code.length < 8) ...[
                const SizedBox(height: 12),
                FrEmptyHint(
                  title: l10n.ftJoinTypingHint,
                  icon: Icons.edit_note_rounded,
                ),
              ],
              const SizedBox(height: 28),
              PrimaryButton(
                label: l10n.ftJoinLobby,
                icon: Icons.login_rounded,
                isLoading: _busy,
                onPressed: _busy ? null : _join,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
