import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FrHubActionCard extends StatefulWidget {
  const FrHubActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  /// When true, the card uses an amber accent border and background tint.
  final bool highlighted;

  @override
  State<FrHubActionCard> createState() => _FrHubActionCardState();
}

class _FrHubActionCardState extends State<FrHubActionCard> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hl = widget.highlighted;

    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: Material(
        color: hl
            ? AppColors.primary.withValues(alpha: 0.10)
            : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: AppColors.primary.withValues(alpha: 0.04),
          onHighlightChanged: (pressed) {
            setState(() => _scale = pressed ? 0.985 : 1);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: hl
                    ? AppColors.primary.withValues(alpha: 0.55)
                    : AppColors.outline,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: hl ? AppColors.primary : null,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
