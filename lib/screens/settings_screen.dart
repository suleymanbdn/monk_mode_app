import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme/app_theme.dart';
import '../features/focus_room/focus_room_identity.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_formatting.dart';
import '../models/app_language.dart';
import '../services/app_update_checker.dart';
import '../services/app_update_navigation.dart';
import '../services/cloud_backup_service.dart';
import '../services/storage_service.dart';
import '../widgets/app_storage_scope.dart';
import 'duration_presets_screen.dart';

/// Public privacy policy URL (GitHub Pages).
const kPrivacyPolicyUrl =
    'https://suleymanbdn.github.io/privacy-policy-monk-mode/privacy-policy.html';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _backupBusy = false;

  String _durationSummary(AppLocalizations l10n) {
    final p = widget.storage.loadDurationPresets();
    return p.map(l10n.formatSessionMinutes).join(' · ');
  }

  void _openDurationPresets() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => DurationPresetsScreen(storage: widget.storage),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  /// Same allowlist as the in-app [kPrivacyPolicyUrl] — blocks accidental
  /// or malicious use if the constant were ever changed.
  static bool _isPrivacyPolicyUrl(String url) {
    try {
      final u = Uri.parse(url);
      return u.isScheme('https') && u.host == 'suleymanbdn.github.io';
    } catch (_) {
      return false;
    }
  }

  Future<void> _openPrivacy() async {
    if (!_isPrivacyPolicyUrl(kPrivacyPolicyUrl)) return;
    final uri = Uri.parse(kPrivacyPolicyUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      final msg = AppLocalizations.of(context).settingsLinkOpenFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _showBackupSignInSetupDialog(
    AppLocalizations l10n,
    BackupSignInKind kind,
  ) async {
    final title = kind == BackupSignInKind.androidDeveloperError
        ? l10n.backupSignInDialogDeveloperTitle
        : l10n.backupSignInDialogTokenTitle;
    final body = kind == BackupSignInKind.androidDeveloperError
        ? l10n.backupSignInDialogDeveloperBody
        : l10n.backupSignInDialogTokenBody;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            body,
            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.backupSignInDialogOk),
          ),
        ],
      ),
    );
  }

  Future<void> _checkForUpdatesFromSettings() async {
    final l10n = AppLocalizations.of(context);
    final r = await AppUpdateChecker.check();
    if (!mounted) return;
    final nav = Navigator.of(context);
    if (r.shouldPrompt) {
      presentAppUpdateScreenIfNeeded(nav, r);
    } else {
      _showSnack(l10n.settingsAppUpToDate);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_backupBusy) return;
    setState(() => _backupBusy = true);
    final l10n = AppLocalizations.of(context);
    try {
      final result = await CloudBackupService.signInWithGoogle();
      if (!mounted) return;
      if (result == null) return; // user cancelled

      if (result.hasCloudData) {
        final local = widget.storage.loadAppStats();
        final cloud = result.cloudStats!;
        if (cloud.totalSessions > local.totalSessions) {
          final restore = await _showRestoreDialog(
            l10n,
            sessions: cloud.totalSessions,
            streak: cloud.effectiveStreak,
          );
          if (!mounted) return;
          if (restore == true) {
            await widget.storage.restoreFromCloudStats(
              cloud,
              togetherTotal: result.cloudTogetherTotal,
            );
            _showSnack(l10n.backupRestored);
            if (mounted) setState(() {});
            return;
          }
        }
      }
      // Local data is at least as good — upload immediately.
      await CloudBackupService.uploadStats(
        widget.storage.loadAppStats(),
        togetherTotal: widget.storage.loadTogetherTotal(),
      );
      if (!mounted) return;
      _showSnack(l10n.backupSynced);
    } on BackupSignInSetupException catch (e) {
      if (!mounted) return;
      await _showBackupSignInSetupDialog(l10n, e.kind);
    } catch (_) {
      if (!mounted) return;
      _showSnack(l10n.backupSignInFailed);
    } finally {
      if (mounted) setState(() => _backupBusy = false);
    }
  }

  Future<void> _syncNow() async {
    if (_backupBusy) return;
    setState(() => _backupBusy = true);
    final l10n = AppLocalizations.of(context);
    try {
      await CloudBackupService.uploadStats(
        widget.storage.loadAppStats(),
        togetherTotal: widget.storage.loadTogetherTotal(),
      );
      if (!mounted) return;
      _showSnack(l10n.backupSynced);
    } catch (_) {
      if (!mounted) return;
      _showSnack(l10n.backupSyncFailed);
    } finally {
      if (mounted) setState(() => _backupBusy = false);
    }
  }

  Future<void> _signOutBackup() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(l10n.backupSignOutConfirmTitle),
        content: Text(l10n.backupSignOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.backupSignOutCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.backupSignOutConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await CloudBackupService.signOut();
    if (mounted) setState(() {});
  }

  Future<bool?> _showRestoreDialog(
    AppLocalizations l10n, {
    required int sessions,
    required int streak,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(l10n.backupRestoreTitle),
        content: Text(l10n.backupRestoreBody(sessions, streak)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.backupRestoreCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.backupRestoreConfirm),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(l10n.resetDialogTitle),
        content: Text(l10n.resetDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.resetDialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.resetDialogConfirm,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final clearedMsg = AppLocalizations.of(context).settingsResetCleared;
    await widget.storage.resetAllData();
    await FocusRoomIdentity.clearLocalFocusIdentity();
    await FocusRoomIdentity.rotateAnonymousAuthIfCloud();
    if (!mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(SnackBar(content: Text(clearedMsg)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // Build the backup group tiles depending on sign-in state
    final List<_SettingsTileData> backupTiles = CloudBackupService.isSignedInWithGoogle
        ? [
            _SettingsTileData(
              icon: Icons.cloud_done_rounded,
              title: l10n.backupSignedInTitle,
              subtitle: l10n.backupSignedInSubtitle(
                CloudBackupService.signedInEmail ?? '',
              ),
              onTap: _backupBusy ? null : _syncNow,
              trailing: _backupBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l10n.backupSyncNow,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
            _SettingsTileData(
              icon: Icons.logout_rounded,
              title: l10n.backupSignOut,
              subtitle: l10n.backupSignOutSubtitle,
              onTap: _signOutBackup,
            ),
          ]
        : [
            _SettingsTileData(
              icon: Icons.login_rounded,
              title: l10n.backupSignInTitle,
              subtitle: l10n.backupSignInSubtitle,
              onTap: _backupBusy ? null : _signInWithGoogle,
              trailing: _backupBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
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
            // TERCİHLER — check for updates (standalone at top)
            _SettingsGroup(
              tiles: [
                _SettingsTileData(
                  icon: Icons.system_update_rounded,
                  title: l10n.settingsCheckForUpdates,
                  subtitle: l10n.settingsCheckForUpdatesSubtitle,
                  onTap: _checkForUpdatesFromSettings,
                ),
              ],
            ),

            // HESAP & YEDEKLEME
            const SizedBox(height: 16),
            _SectionLabel(label: l10n.settingsBackup, theme: theme),
            const SizedBox(height: 8),
            _SettingsGroup(tiles: backupTiles),

            // DİL
            const SizedBox(height: 16),
            _SectionLabel(label: l10n.settingsLanguage, theme: theme),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<AppLanguage>(
                      segments: [
                        ButtonSegment<AppLanguage>(
                          value: AppLanguage.en,
                          label: Text(l10n.languageEnglishName),
                        ),
                        ButtonSegment<AppLanguage>(
                          value: AppLanguage.tr,
                          label: Text(l10n.languageTurkishName),
                        ),
                      ],
                      selected: {widget.storage.loadAppLanguage()},
                      onSelectionChanged: (next) {
                        if (next.isEmpty) return;
                        final v = next.first;
                        final loc = v == AppLanguage.tr
                            ? const Locale('tr')
                            : const Locale('en');
                        AppStorageScope.setLocale(context, loc).then((_) {
                          if (mounted) setState(() {});
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.languagePickerSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ODAK
            const SizedBox(height: 16),
            _SectionLabel(label: l10n.settingsFocus, theme: theme),
            const SizedBox(height: 8),
            _SettingsGroup(
              tiles: [
                _SettingsTileData(
                  icon: Icons.timer_outlined,
                  title: l10n.settingsSessionChipsTitle,
                  subtitle: _durationSummary(l10n),
                  onTap: _openDurationPresets,
                ),
              ],
            ),

            // YASAL
            const SizedBox(height: 16),
            _SectionLabel(label: l10n.settingsLegal, theme: theme),
            const SizedBox(height: 8),
            _SettingsGroup(
              tiles: [
                _SettingsTileData(
                  icon: Icons.policy_outlined,
                  title: l10n.settingsPrivacyTitle,
                  subtitle: l10n.settingsPrivacySubtitle,
                  onTap: _openPrivacy,
                ),
              ],
            ),

            // VERİ
            const SizedBox(height: 16),
            _SectionLabel(label: l10n.settingsData, theme: theme),
            const SizedBox(height: 8),
            _SettingsGroup(
              tiles: [
                _SettingsTileData(
                  icon: Icons.delete_outline_rounded,
                  title: l10n.settingsResetTitle,
                  subtitle: l10n.settingsResetSubtitle,
                  onTap: _confirmReset,
                  danger: true,
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data holder for a single tile's properties
// ---------------------------------------------------------------------------

class _SettingsTileData {
  const _SettingsTileData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool danger;
  final Widget? trailing;
}

// ---------------------------------------------------------------------------
// Section label
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.theme});

  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: AppColors.onSurfaceSubtle,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Group container that wraps multiple tiles with dividers between them
// ---------------------------------------------------------------------------

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.tiles});

  final List<_SettingsTileData> tiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            for (int i = 0; i < tiles.length; i++) ...[
              _SettingsTile(data: tiles[i]),
              if (i < tiles.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.borderSubtle,
                  indent: 52,
                  endIndent: 0,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual tile — no outer border/container (lives inside _SettingsGroup)
// ---------------------------------------------------------------------------

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.data});

  final _SettingsTileData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = data.danger ? AppColors.error : AppColors.onSurfaceVariant;

    final row = Row(
      children: [
        Icon(
          data.icon,
          color: data.danger ? AppColors.error : AppColors.primary,
          size: 22,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: data.danger ? AppColors.error : AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
        if (data.trailing != null)
          data.trailing!
        else if (data.onTap != null)
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.onSurfaceSubtle,
            size: 22,
          ),
      ],
    );

    final padded = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: row,
    );

    if (data.onTap == null) return padded;

    return InkWell(
      onTap: data.onTap,
      child: padded,
    );
  }
}
