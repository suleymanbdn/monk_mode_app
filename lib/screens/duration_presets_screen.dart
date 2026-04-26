import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_formatting.dart';
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

  Widget _dropdown({
    required AppLocalizations l10n,
    required String title,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.outline),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surfaceContainerHigh,
              items: StorageService.allowedFocusMinutes
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(l10n.formatSessionMinutes(m)),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                onChanged(v);
              },
            ),
          ),
        ),
      ],
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
            _dropdown(
              l10n: l10n,
              title: l10n.durationPresetsFirst,
              value: _first,
              onChanged: (v) => setState(() => _first = v),
            ),
            const SizedBox(height: 18),
            _dropdown(
              l10n: l10n,
              title: l10n.durationPresetsSecond,
              value: _second,
              onChanged: (v) => setState(() => _second = v),
            ),
            const SizedBox(height: 18),
            _dropdown(
              l10n: l10n,
              title: l10n.durationPresetsThird,
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
