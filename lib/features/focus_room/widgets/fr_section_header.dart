import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FrSectionHeader extends StatelessWidget {
  const FrSectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        letterSpacing: 1.4,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
