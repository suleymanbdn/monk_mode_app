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
import 'stats_screen.dart';

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
              _AppHeader(
                l10n: l10n,
                onSettingsTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(storage: widget.storage),
                  ),
                ).then((_) => _refresh()),
                onStatsTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StatsScreen(storage: widget.storage),
                  ),
                ).then((_) => _refresh()),
              ),
              const SizedBox(height: 36),
              _HeroSection(title: l10n.heroTitle, tagline: _tagline(l10n)),
              const SizedBox(height: 28),
              _DopamineScoreCard(score: _stats.dopamineScore, l10n: l10n),
              const SizedBox(height: 16),
              _StreakCard(stats: _stats, l10n: l10n),
              const SizedBox(height: 16),
              _FocusTimeCard(
                totalMinutes: _stats.totalMinutes,
                totalSessions: _stats.totalSessions,
                l10n: l10n,
              ),
              const SizedBox(height: 32),
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
              const SizedBox(height: 12),
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

// ── Header ────────────────────────────────────────────────────────────────────

class _AppHeader extends StatelessWidget {
  const _AppHeader({
    required this.l10n,
    required this.onSettingsTap,
    required this.onStatsTap,
  });

  final AppLocalizations l10n;
  final VoidCallback onSettingsTap;
  final VoidCallback onStatsTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _HeaderIconButton(
          icon: Icons.settings_rounded,
          tooltip: l10n.settingsTooltip,
          onPressed: onSettingsTap,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.appTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                l10n.appSubtitle,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
        ),
        _HeaderIconButton(
          icon: Icons.bar_chart_rounded,
          tooltip: l10n.statsTooltip,
          onPressed: onStatsTap,
        ),
      ],
    );
  }
}

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

// ── Hero ──────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.title, required this.tagline});

  final String title;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          tagline,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Dopamine Score Card ───────────────────────────────────────────────────────

class _DopamineScoreCard extends StatelessWidget {
  const _DopamineScoreCard({required this.score, required this.l10n});

  final int score;
  final AppLocalizations l10n;

  String _label() {
    if (score == 0) return l10n.dopamineLabel0;
    if (score < 20) return l10n.dopamineLabel20;
    if (score < 45) return l10n.dopamineLabel45;
    if (score < 70) return l10n.dopamineLabel70;
    if (score < 90) return l10n.dopamineLabel90;
    return l10n.dopamineLabel100;
  }

  // Gold for early progress — green only when score is genuinely high.
  // Avoids showing red which feels discouraging when the user is just starting.
  Color _barColor(double progress) {
    if (progress < 0.6) return AppColors.primary;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = score / 100.0;
    final barColor = _barColor(progress);
    final hasScore = score > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          // Subtle gold tint once the user has earned any points.
          color: hasScore ? AppColors.primaryDim : AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l10n.dopamineScoreTitle, style: theme.textTheme.labelMedium),
              const Spacer(),
              _ScorePill(score: score),
            ],
          ),
          const SizedBox(height: 18),
          _ProgressBar(progress: progress, color: barColor),
          const SizedBox(height: 14),
          Text(
            _label(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$score',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 2),
        Text('/ 100', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final filledWidth = constraints.maxWidth * progress;
        return Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              height: 6,
              width: filledWidth.clamp(0.0, constraints.maxWidth),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.7), color],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Streak Card ───────────────────────────────────────────────────────────────
//
// Shows the current streak with a "completed today" status dot.
// Uses effectiveStreak so a missed day always shows 0 immediately.

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.stats, required this.l10n});

  final AppStats stats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final streak = stats.effectiveStreak;
    final doneToday = stats.completedToday;
    final hasStreak = streak > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          // Gold border when streak is alive, dim when not.
          color: hasStreak ? AppColors.primaryDim : AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: hasStreak
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: hasStreak ? AppColors.primary : AppColors.onSurfaceSubtle,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$streak',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: hasStreak
                            ? AppColors.primary
                            : AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.dayStreakSuffix,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.bestStreak(stats.longestStreak),
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          _TodayDot(done: doneToday, todayLabel: l10n.todayLabel),
        ],
      ),
    );
  }
}

/// A small pill that shows whether today's session has been completed.
class _TodayDot extends StatelessWidget {
  const _TodayDot({required this.done, required this.todayLabel});

  final bool done;
  final String todayLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: done
                ? AppColors.success.withValues(alpha: 0.12)
                : AppColors.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(
              color: done ? AppColors.success : AppColors.outline,
              width: 1.5,
            ),
          ),
          child: Icon(
            done ? Icons.check_rounded : Icons.circle_outlined,
            size: 16,
            color: done ? AppColors.success : AppColors.onSurfaceSubtle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          todayLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 9,
            color: done ? AppColors.success : AppColors.onSurfaceSubtle,
          ),
        ),
      ],
    );
  }
}

// ── Focus Time Card ───────────────────────────────────────────────────────────
//
// Shows two stats side by side: total focus time and total sessions completed.

class _FocusTimeCard extends StatelessWidget {
  const _FocusTimeCard({
    required this.totalMinutes,
    required this.totalSessions,
    required this.l10n,
  });

  final int totalMinutes;
  final int totalSessions;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final timeLabel = totalMinutes == 0
        ? '0 min'
        : TimeUtils.formatTotalMinutes(totalMinutes);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              icon: Icons.timer_outlined,
              iconColor: AppColors.success,
              value: timeLabel,
              label: l10n.focusTimeStatLabel,
            ),
          ),
          Container(
            width: 1,
            height: 44,
            color: AppColors.outline,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: _StatColumn(
              icon: Icons.check_circle_outline_rounded,
              iconColor: AppColors.primary,
              value: '$totalSessions',
              label: l10n.sessionsDoneStatLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 1),
              Text(label, style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ],
    );
  }
}

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
