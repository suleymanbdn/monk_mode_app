import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/app_stats.dart';
import '../services/storage_service.dart';
import '../utils/time_utils.dart';
import '../widgets/primary_button.dart';
import '../features/focus_room/focus_room_navigation.dart';
import '../features/focus_room/screens/focus_room_home_screen.dart';
import '../features/focus_room/widgets/fr_circle_journey_card.dart';
import 'monk_mode_screen.dart';
import 'settings_screen.dart';
import 'session_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppStats _stats;

  @override
  void initState() {
    super.initState();
    _stats = widget.storage.loadAppStats();
  }

  void _refresh() => setState(() => _stats = widget.storage.loadAppStats());

  String _tagline(AppLocalizations l10n) {
    if (_stats.totalSessions == 0) return l10n.taglineSessionsZero;
    if (_stats.effectiveStreak == 0) return l10n.taglineStreakZero;
    if (_stats.effectiveStreak < 3) return l10n.taglineStreakLt3;
    if (_stats.effectiveStreak < 7) return l10n.taglineStreakLt7;
    return l10n.taglineStreakGe7;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // ── Header: history left, settings right ──────────────────────
              Row(
                children: [
                  _HeaderIconButton(
                    icon: Icons.history_rounded,
                    tooltip: l10n.statsTooltip,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SessionHistoryScreen(storage: widget.storage),
                      ),
                    ).then((_) => _refresh()),
                  ),
                  const Spacer(),
                  _HeaderIconButton(
                    icon: Icons.settings_rounded,
                    tooltip: l10n.settingsTooltip,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(storage: widget.storage),
                      ),
                    ).then((_) => _refresh()),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // ── Greeting label ────────────────────────────────────────────
              Text(
                'GÜNAYDIN',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 12),
              // ── Session badge ─────────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: _SessionBadge(completedToday: _stats.completedToday),
              ),
              const SizedBox(height: 16),
              // ── Hero title ────────────────────────────────────────────────
              Text(
                _tagline(l10n),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.appSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              // ── CTA button ────────────────────────────────────────────────
              PrimaryButton(
                label: l10n.startMonkMode,
                icon: Icons.self_improvement_rounded,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MonkModeScreen(storage: widget.storage),
                  ),
                ).then((_) => _refresh()),
              ),
              const SizedBox(height: 20),
              // ── Two stat cards side-by-side ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _MiniStatCard(
                      icon: Icons.local_fire_department_rounded,
                      value: _stats.effectiveStreak,
                      label: 'GÜNLÜK SERİ',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MiniStatCard(
                      icon: Icons.bolt_rounded,
                      value: _stats.dopamineScore,
                      label: 'DOPAMİN SKORU',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // ── Focus Together button ─────────────────────────────────────
              PrimaryButton(
                label: l10n.focusTogether,
                outlined: true,
                icon: Icons.groups_rounded,
                onPressed: () => Navigator.push(
                  context,
                  focusRoomFadeRoute(const FocusRoomHomeScreen()),
                ).then((_) => _refresh()),
              ),
              const SizedBox(height: 16),
              // ── Focus time stat row ───────────────────────────────────────
              _FocusTimeRow(
                totalMinutes: _stats.totalMinutes,
              ),
              const SizedBox(height: 20),
              // ── Circle journey teaser ─────────────────────────────────────
              Text(
                l10n.circleJourneySection,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              _HomeCircleJourneyTeaser(storage: widget.storage),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header Icon Button ────────────────────────────────────────────────────────

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.surfaceContainer,
        side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(40, 40),
        fixedSize: const Size(40, 40),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
    );
  }
}

// ── Session Badge ─────────────────────────────────────────────────────────────

class _SessionBadge extends StatelessWidget {
  const _SessionBadge({required this.completedToday});

  final bool completedToday;

  @override
  Widget build(BuildContext context) {
    final count = completedToday ? 1 : 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_rounded,
            size: 12,
            color: AppColors.primary,
          ),
          const SizedBox(width: 3),
          Text(
            'Bugün $count oturum',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini Stat Card ────────────────────────────────────────────────────────────

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            '$value',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: hasValue ? AppColors.primary : AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

// ── Focus Time Row ────────────────────────────────────────────────────────────

class _FocusTimeRow extends StatelessWidget {
  const _FocusTimeRow({required this.totalMinutes});

  final int totalMinutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeLabel = totalMinutes == 0
        ? '0 min'
        : TimeUtils.formatTotalMinutes(totalMinutes);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: AppColors.success,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            timeLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'toplam odaklanma',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Circle Journey Teaser ─────────────────────────────────────────────────────

class _HomeCircleJourneyTeaser extends StatelessWidget {
  const _HomeCircleJourneyTeaser({required this.storage});

  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return FrCircleJourneyCard(
      progress: storage.loadFocusTogetherCircleProgress(),
      compact: true,
    );
  }
}
