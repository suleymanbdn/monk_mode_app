import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../focus_room_runtime.dart';

/// Explains offline vs online Focus Together behavior.
enum FrCrossDeviceWarningVariant { hub, joinScreen, lobbyHost }

class FrCrossDeviceWarning extends StatelessWidget {
  const FrCrossDeviceWarning({super.key, required this.variant});

  final FrCrossDeviceWarningVariant variant;

  String _title(AppLocalizations l10n) => focusRoomCloudSyncEnabled
      ? switch (variant) {
          FrCrossDeviceWarningVariant.hub => l10n.frCrossHubTitleOn,
          FrCrossDeviceWarningVariant.joinScreen => l10n.frCrossJoinTitleOn,
          FrCrossDeviceWarningVariant.lobbyHost => l10n.frCrossLobbyTitleOn,
        }
      : switch (variant) {
          FrCrossDeviceWarningVariant.hub => l10n.frCrossHubTitleOff,
          FrCrossDeviceWarningVariant.joinScreen => l10n.frCrossJoinTitleOff,
          FrCrossDeviceWarningVariant.lobbyHost => l10n.frCrossLobbyTitleOff,
        };

  String _body(AppLocalizations l10n) => focusRoomCloudSyncEnabled
      ? switch (variant) {
          FrCrossDeviceWarningVariant.hub => l10n.frCrossHubBodyOn,
          FrCrossDeviceWarningVariant.joinScreen => l10n.frCrossJoinBodyOn,
          FrCrossDeviceWarningVariant.lobbyHost => l10n.frCrossLobbyBodyOn,
        }
      : switch (variant) {
          FrCrossDeviceWarningVariant.hub => l10n.frCrossHubBodyOff,
          FrCrossDeviceWarningVariant.joinScreen => l10n.frCrossJoinBodyOff,
          FrCrossDeviceWarningVariant.lobbyHost => l10n.frCrossLobbyBodyOff,
        };

  IconData get _icon => focusRoomCloudSyncEnabled
      ? Icons.cloud_done_rounded
      : Icons.phonelink_lock_rounded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_icon, size: 22, color: AppColors.tertiary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _title(l10n),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              _body(l10n),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
