import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../focus_room_identity.dart';
import '../focus_room_navigation.dart';
import '../focus_room_runtime.dart';
import '../state/focus_room_controller.dart';
import '../../../widgets/app_storage_scope.dart';
import '../widgets/fr_card.dart';
import '../widgets/fr_circle_journey_card.dart';
import '../widgets/fr_cross_device_warning.dart';
import '../widgets/fr_hub_action_card.dart';
import '../widgets/fr_section_header.dart';
import 'create_room_screen.dart';
import 'join_room_screen.dart';

/// Hub: create or join a shared focus session.
class FocusRoomHomeScreen extends StatefulWidget {
  const FocusRoomHomeScreen({super.key});

  @override
  State<FocusRoomHomeScreen> createState() => _FocusRoomHomeScreenState();
}

class _FocusRoomHomeScreenState extends State<FocusRoomHomeScreen> {
  FocusRoomController? _controller;
  final TextEditingController _nameCtrl = TextEditingController();
  bool _contentVisible = false;

  @override
  void initState() {
    super.initState();
    _bootstrapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _contentVisible = true);
    });
  }

  Future<void> _bootstrapController() async {
    await FocusRoomIdentity.ensureSignedInForCloud();
    if (!mounted) return;
    final id = await FocusRoomIdentity.loadOrCreate();
    if (!mounted) return;
    _nameCtrl.text = id.displayName;
    setState(() {
      _controller = FocusRoomController(
        repository: focusRoomRepository,
        localUserId: id.userId,
        localDisplayName: id.displayName,
      );
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _saveDisplayName() async {
    final l10n = AppLocalizations.of(context);
    final raw = _nameCtrl.text;
    if (raw.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ftErrorNameEmpty)));
      return;
    }
    await FocusRoomIdentity.saveDisplayName(raw);
    _controller?.setLocalDisplayName(raw);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.ftNameSavedSnackbar),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final c = _controller;

    if (c == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.ftHubTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ftHubTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: AnimatedOpacity(
            opacity: _contentVisible ? 1 : 0,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              offset: _contentVisible ? Offset.zero : const Offset(0, 0.02),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                children: [
                  Text(
                    l10n.ftHubHeadline,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    focusRoomCloudSyncEnabled
                        ? l10n.ftHubBodyOnline
                        : l10n.ftHubBodyOffline,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const FrCrossDeviceWarning(
                    variant: FrCrossDeviceWarningVariant.hub,
                  ),
                  if (AppStorageScope.maybeOf(context) case final storage?) ...[
                    const SizedBox(height: 20),
                    FrCircleJourneyCard(
                      progress: storage.loadFocusTogetherCircleProgress(),
                      compact: false,
                    ),
                  ],
                  const SizedBox(height: 24),
                  FrSectionHeader(l10n.ftYourNameHeader),
                  const SizedBox(height: 10),
                  FrCard(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _nameCtrl,
                          maxLength: 20,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: l10n.ftNameFieldHint,
                            border: InputBorder.none,
                            counterText: '',
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.ftNameHelp,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _saveDisplayName,
                            icon: const Icon(Icons.check_rounded, size: 20),
                            label: Text(l10n.ftSaveName),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  FrSectionHeader(l10n.ftStartHere),
                  const SizedBox(height: 14),
                  FrHubActionCard(
                    title: l10n.ftCreateRoomTitle,
                    subtitle: l10n.ftCreateRoomSubtitle,
                    icon: Icons.add_circle_outline_rounded,
                    onTap: () => Navigator.push<void>(
                      context,
                      focusRoomFadeRoute(CreateRoomScreen(controller: c)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FrHubActionCard(
                    title: l10n.ftJoinRoomTitle,
                    subtitle: focusRoomCloudSyncEnabled
                        ? l10n.ftJoinRoomSubtitleOnline
                        : l10n.ftJoinRoomSubtitleOffline,
                    icon: Icons.login_rounded,
                    onTap: () => Navigator.push<void>(
                      context,
                      focusRoomFadeRoute(JoinRoomScreen(controller: c)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
