import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/focus_together_circle_l10n.dart';
import '../../../models/focus_together_circle_progress.dart';
import 'fr_card.dart';
import 'fr_section_header.dart';

/// Hub / home / stats: shows honest next-step progress (local count only).
class FrCircleJourneyCard extends StatelessWidget {
  const FrCircleJourneyCard({
    super.key,
    required this.progress,
    this.compact = false,
  });

  final FocusTogetherCircleProgress progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final p = progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) ...[
          FrSectionHeader(l10n.circleJourneySection),
          const SizedBox(height: 10),
        ],
        FrCard(
          padding: EdgeInsets.all(compact ? 14 : 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    p.allNamedTiersComplete
                        ? Icons.emoji_events_rounded
                        : Icons.track_changes_rounded,
                    color: AppColors.primary,
                    size: compact ? 22 : 26,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.localizedHeadline(l10n),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          p.localizedSubline(l10n),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!p.allNamedTiersComplete) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: p.segmentProgress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  p.localizedFooterLine(l10n),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 10),
                Text(
                  l10n.ftFooterAllDone(p.naturalCompletions),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
