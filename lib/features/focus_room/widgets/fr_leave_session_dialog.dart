import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/primary_button.dart';

/// Premium bottom sheet: primary action stays on focus, destructive / forward on outline.
///
/// Returns `true` when the user chooses the secondary (outline) action.
Future<bool> showFocusRoomLeaveSessionDialog(
  BuildContext context, {
  String? title,
  String? body,
  String? primaryLabel,
  String? secondaryLabel,
}) async {
  final theme = Theme.of(context);
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      return Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.of(ctx).padding.bottom,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title ?? l10n.ftLeaveSessionTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  body ?? l10n.ftLeaveSessionBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  label: primaryLabel ?? l10n.ftKeepFocusing,
                  icon: Icons.timer_outlined,
                  onPressed: () => Navigator.pop(ctx, false),
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  label: secondaryLabel ?? l10n.ftEndSessionSheet,
                  outlined: true,
                  icon: Icons.logout_rounded,
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return result == true;
}
