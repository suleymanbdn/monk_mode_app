import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/storage_service.dart';

/// Lets the user choose three distinct session lengths (minutes) for Monk Mode.
class DurationPresetsScreen extends StatefulWidget {
  const DurationPresetsScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<DurationPresetsScreen> createState() => _DurationPresetsScreenState();
}

class _DurationPresetsScreenState extends State<DurationPresetsScreen> {
  late int _first;
  late int _second;
  late int _third;

  @override
  void initState() {
    super.initState();
    final p = widget.storage.loadDurationPresets();
    _first = p[0];
    _second = p[1];
    _third = p[2];
  }

  Future<void> _save() async {
    if ({_first, _second, _third}.length != 3) {
      final msg = AppLocalizations.of(context).durationPresetsDistinctError;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    await widget.storage.saveDurationPresets([_first, _second, _third]);
    if (!mounted) return;
    Navigator.pop(context);
  }

  /// Snaps a raw slider double to the nearest value in [StorageService.allowedFocusMinutes].
  int _snapToAllowed(double raw) {
    final allowed = StorageService.allowedFocusMinutes;
    int nearest = allowed.first;
    int minDiff = (raw - nearest).abs().round();
    for (final v in allowed) {
      final diff = (raw - v).abs().round();
      if (diff < minDiff) {
        minDiff = diff;
        nearest = v;
      }
    }
    return nearest;
  }

  Widget _presetCard({
    required AppLocalizations l10n,
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$value',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' dk',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.borderSubtle,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.16),
              trackHeight: 3,
            ),
            child: Slider(
              value: value.toDouble(),
              min: 5,
              max: 180,
              divisions: 35,
              onChanged: (raw) {
                onChanged(_snapToAllowed(raw));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.durationPresetsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            Text(l10n.durationPresetsIntro, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            _presetCard(
              l10n: l10n,
              label: l10n.durationPresetsFirst,
              value: _first,
              onChanged: (v) => setState(() => _first = v),
            ),
            const SizedBox(height: 16),
            _presetCard(
              l10n: l10n,
              label: l10n.durationPresetsSecond,
              value: _second,
              onChanged: (v) => setState(() => _second = v),
            ),
            const SizedBox(height: 16),
            _presetCard(
              l10n: l10n,
              label: l10n.durationPresetsThird,
              value: _third,
              onChanged: (v) => setState(() => _third = v),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l10n.durationPresetsSave,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
