import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class FrRoomCodeBlock extends StatelessWidget {
  const FrRoomCodeBlock({super.key, required this.code, this.label});

  final String code;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final formatted = _format(code);
    final effectiveLabel = label ?? l10n.ftRoomCodeLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          effectiveLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            letterSpacing: 1.2,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primaryDim.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  formatted,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filledTonal(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: code.replaceAll(RegExp(r'\s'), '')),
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.ftCodeCopied)));
              },
              icon: const Icon(Icons.copy_rounded, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _format(String raw) {
    final c = raw.replaceAll(RegExp(r'\s'), '').toUpperCase();
    if (c.length <= 4) return c;
    return '${c.substring(0, 4)} ${c.substring(4)}';
  }
}
