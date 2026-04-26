import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/app_update_checker.dart';

/// Full-screen prompt when Firestore [app_config] reports a newer store build.
/// No CTA buttons: the whole screen opens the store on tap.
class AppUpdateScreen extends StatefulWidget {
  const AppUpdateScreen({super.key, required this.result});

  final AppUpdateCheckResult result;

  @override
  State<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends State<AppUpdateScreen> {
  bool _launching = false;

  Future<void> _openStore() async {
    if (_launching) return;
    _launching = true;
    final uri = Uri.parse(widget.result.storeUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    _launching = false;
    if (!ok) {
      final msg = AppLocalizations.of(context).updateStoreOpenFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final force = widget.result.forceUpdate;
    final r = widget.result;

    final content = _UpdateBackground(
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _openStore,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (force) const SizedBox(height: 8),
                      _UpdateBadge(
                        text: force
                            ? l10n.updateBadgeRequired
                            : l10n.updateBadgeRecommended,
                        strong: force,
                      ),
                      const SizedBox(height: 28),
                      _HeroIcon(
                        icon: force
                            ? Icons.system_update_alt_rounded
                            : Icons.new_releases_rounded,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        force
                            ? l10n.updateRequiredTitle
                            : l10n.updateAvailableTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        force
                            ? l10n.updateRequiredBody
                            : l10n.updateAvailableBody,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.updateVersionStatusTitle,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceSubtle,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _VersionCard(
                              label: l10n.updateYouAreOn,
                              version: r.currentVersion,
                              highlighted: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _VersionCard(
                              label: l10n.updateLatestIs,
                              version: r.latestVersion,
                              highlighted: true,
                            ),
                          ),
                        ],
                      ),
                      if (r.message != null && r.message!.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.updateReleaseNotesTitle,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.onSurfaceSubtle,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Text(
                            r.message!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                      Icon(
                        Icons.touch_app_rounded,
                        size: 36,
                        color: AppColors.primary.withValues(alpha: 0.85),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.updateTapToOpenStore,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (force) {
      return PopScope(
        canPop: false,
        child: Scaffold(backgroundColor: AppColors.background, body: content),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.updateScreenAppBar),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        ),
      ),
      body: content,
    );
  }
}

class _UpdateBackground extends StatelessWidget {
  const _UpdateBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                Color(0xFF0C0C0C),
                AppColors.background,
              ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: IgnorePointer(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.06),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -60,
          child: IgnorePointer(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withValues(alpha: 0.04),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _UpdateBadge extends StatelessWidget {
  const _UpdateBadge({required this.text, required this.strong});

  final String text;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = strong
        ? AppColors.error.withValues(alpha: 0.12)
        : AppColors.primaryContainer;
    final fg = strong ? const Color(0xFFFF8A8A) : AppColors.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: strong
              ? AppColors.error.withValues(alpha: 0.35)
              : AppColors.outline,
        ),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceContainer,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, size: 44, color: AppColors.primary),
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard({
    required this.label,
    required this.version,
    required this.highlighted,
  });

  final String label;
  final String version;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = highlighted
        ? AppColors.primary.withValues(alpha: 0.5)
        : AppColors.outline;
    final bg = highlighted
        ? AppColors.primaryContainer.withValues(alpha: 0.5)
        : AppColors.surfaceContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: highlighted ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            version,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
