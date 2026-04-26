import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_formatting.dart';
import '../../../widgets/primary_button.dart';
import '../focus_room_navigation.dart';
import '../state/focus_room_controller.dart';
import '../widgets/fr_card.dart';
import '../widgets/fr_duration_chip.dart';
import '../widgets/fr_section_header.dart';
import 'room_lobby_screen.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key, required this.controller});

  final FocusRoomController controller;

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _nameController = TextEditingController();
  late int _minutes;
  static const _durationOptions = [15, 25, 30, 45, 60];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _minutes = _durationOptions[2];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.controller.createAndEnterRoom(
        name: _nameController.text.trim(),
        durationMinutes: _minutes,
      );
      if (!mounted) return;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ftCreateAppBar),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: _busy ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            Text(
              l10n.ftCreateDurationQuestion,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.ftCreateDurationHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _durationOptions.map((m) {
                return FrDurationChip(
                  label: l10n.formatSessionMinutes(m),
                  selected: _minutes == m,
                  onTap: () {
                    if (_busy) return;
                    setState(() => _minutes = m);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            FrSectionHeader(l10n.ftNameOptionalSection),
            const SizedBox(height: 12),
            FrCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _nameController,
                enabled: !_busy,
                maxLength: 40,
                style: theme.textTheme.bodyLarge,
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: l10n.ftRoomNameHint,
                  border: InputBorder.none,
                  counterText: '',
                  hintStyle: TextStyle(color: AppColors.onSurfaceSubtle),
                ),
              ),
            ),
            const SizedBox(height: 36),
            PrimaryButton(
              label: l10n.ftCreateOpenLobby,
              icon: Icons.groups_rounded,
              isLoading: _busy,
              onPressed: _busy ? null : _create,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
