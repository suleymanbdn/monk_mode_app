import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_formatting.dart';
import '../features/focus_room/widgets/fr_circle_journey_card.dart';
import '../models/app_stats.dart';
import '../models/session_log_entry.dart';
import '../services/storage_service.dart';
import '../utils/time_utils.dart';
import 'session_history_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late AppStats _stats;

  @override
  void initState() {
    super.initState();
    _stats = widget.storage.loadAppStats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hasData = _stats.totalSessions > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _DopamineHero(score: _stats.dopamineScore),
              const SizedBox(height: 20),
              Text(l10n.statsYourStats, style: theme.textTheme.labelMedium),
              const SizedBox(height: 14),
              _StatsGrid(stats: _stats, l10n: l10n),
              if (_stats.lastSessionDate != null) ...[
                const SizedBox(height: 10),
                _LastSessionRow(dateKey: _stats.lastSessionDate!, l10n: l10n),
              ],
              const SizedBox(height: 14),
              _SessionHistoryRow(
                l10n: l10n,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SessionHistoryScreen(storage: widget.storage),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('HAFTALİK İLERLEME', style: theme.textTheme.labelMedium),
              const SizedBox(height: 14),
              _WeeklyChart(sessionLog: widget.storage.loadSessionLog()),
              const SizedBox(height: 24),
              FrCircleJourneyCard(
                progress: widget.storage.loadFocusTogetherCircleProgress(),
                compact: false,
              ),
              const SizedBox(height: 20),
              Text(l10n.statsStreakJourney, style: theme.textTheme.labelMedium),
              const SizedBox(height: 14),
              _MilestoneBand(streak: _stats.effectiveStreak, l10n: l10n),
              if (!hasData) ...[
                const SizedBox(height: 40),
                _EmptyState(l10n: l10n),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── ① Dopamine Score Hero ─────────────────────────────────────────────────────

class _DopamineHero extends StatelessWidget {
  const _DopamineHero({required this.score});

  final int score;

  String _description(AppLocalizations l10n) {
    if (score == 0) return l10n.dopamineLabel0;
    if (score < 20) return l10n.dopamineLabel20;
    if (score < 45) return l10n.dopamineLabel45;
    if (score < 70) return l10n.dopamineLabel70;
    if (score < 90) return l10n.dopamineLabel90;
    return l10n.dopamineLabel100;
  }

  Color _barColor() {
    if (score < 60) return AppColors.primary;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final barColor = _barColor();
    final progress = (score / 100.0).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(l10n.dopamineScoreTitle, style: theme.textTheme.labelMedium),
          const SizedBox(height: 16),
          Text(
            '$score',
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'DOPAMIN SKORU',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
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
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          barColor.withValues(alpha: 0.7),
                          barColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: barColor.withValues(alpha: 0.45),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            _description(l10n),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── ② Weekly Chart ────────────────────────────────────────────────────────────

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.sessionLog});

  final List<SessionLogEntry> sessionLog;

  static const _maxBarHeight = 80.0;
  static const _dayLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    // Build list of last 7 days (oldest first)
    final days = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      return d;
    });

    // Aggregate minutes per dateKey
    final minutesByKey = <String, int>{};
    for (final entry in sessionLog) {
      minutesByKey[entry.dateKey] =
          (minutesByKey[entry.dateKey] ?? 0) + entry.durationMinutes;
    }

    // Build per-day minutes
    final minutesPerDay = days.map((d) {
      final key = TimeUtils.dateKey(d);
      return minutesByKey[key] ?? 0;
    }).toList();

    final maxMinutes = minutesPerDay.fold(0, (a, b) => a > b ? a : b);

    final todayKey = TimeUtils.todayKey;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final day = days[i];
          final key = TimeUtils.dateKey(day);
          final minutes = minutesPerDay[i];
          final isToday = key == todayKey;
          final hasData = minutes > 0;
          final barHeight = maxMinutes == 0
              ? 0.0
              : (minutes / maxMinutes) * _maxBarHeight;
          final clampedHeight = barHeight.clamp(4.0, _maxBarHeight);

          final barColor = isToday
              ? AppColors.primary
              : hasData
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.surfaceContainerHighest;

          final dayIndex = (day.weekday - 1) % 7; // Mon=0 .. Sun=6

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: _maxBarHeight,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      width: 20,
                      height: hasData ? clampedHeight : 4,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _dayLabels[dayIndex],
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isToday
                        ? AppColors.primary
                        : AppColors.onSurfaceSubtle,
                    fontSize: 10,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── ③ Stats Grid ──────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats, required this.l10n});

  final AppStats stats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.primary,
                value: '${stats.effectiveStreak}',
                unit: stats.effectiveStreak == 1
                    ? l10n.statsUnitDay
                    : l10n.statsUnitDays,
                label: l10n.statsCurrentStreak,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                icon: Icons.check_circle_outline_rounded,
                iconColor: AppColors.success,
                value: '${stats.totalSessions}',
                unit: stats.totalSessions == 1
                    ? l10n.statsUnitSession
                    : l10n.statsUnitSessions,
                label: l10n.statsCompleted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.timer_outlined,
                iconColor: AppColors.tertiary,
                value: l10n.formatTotalFocusMinutes(stats.totalMinutes),
                label: l10n.statsTotalFocus,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                icon: Icons.emoji_events_rounded,
                iconColor: AppColors.onPrimaryContainer,
                value: '${stats.longestStreak}',
                unit: stats.longestStreak == 1
                    ? l10n.statsUnitDay
                    : l10n.statsUnitDays,
                label: l10n.statsBestStreak,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.unit = '',
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tinted icon container
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 19),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    unit,
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _MilestoneBand extends StatelessWidget {
  const _MilestoneBand({required this.streak, required this.l10n});

  final int streak;
  final AppLocalizations l10n;

  static const _milestones = [3, 7, 14, 30];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextMilestone = _milestones.firstWhere(
      (m) => m > streak,
      orElse: () => 30,
    );
    final daysLeft = nextMilestone - streak;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                streak >= 30
                    ? l10n.statsMilestoneBeyond
                    : daysLeft == 1
                    ? l10n.statsMilestoneOneDayTo(nextMilestone)
                    : l10n.statsMilestoneDaysTo(daysLeft, nextMilestone),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _MilestoneTrack(streak: streak, milestones: _milestones),
        ],
      ),
    );
  }
}

class _MilestoneTrack extends StatelessWidget {
  const _MilestoneTrack({required this.streak, required this.milestones});

  final int streak;
  final List<int> milestones;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final segments = milestones.length;

    return Row(
      children: List.generate(segments, (i) {
        final milestoneValue = milestones[i];
        final prevValue = i == 0 ? 0 : milestones[i - 1];
        final reached = streak >= milestoneValue;
        final partial = !reached && streak > prevValue;
        final segmentFill = partial
            ? (streak - prevValue) / (milestoneValue - prevValue).toDouble()
            : reached
            ? 1.0
            : 0.0;

        final isLast = i == segments - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(child: _SegmentLine(fill: segmentFill)),
              Column(
                children: [
                  _MilestoneDot(reached: reached),
                  const SizedBox(height: 6),
                  Text(
                    '${milestoneValue}d',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: reached
                          ? AppColors.primary
                          : AppColors.onSurfaceSubtle,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              if (isLast) const SizedBox(width: 4),
            ],
          ),
        );
      }),
    );
  }
}

class _SegmentLine extends StatelessWidget {
  const _SegmentLine({required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: 2,
              width: double.infinity,
              color: AppColors.surfaceContainerHighest,
            ),
            Container(
              height: 2,
              width: constraints.maxWidth * fill.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MilestoneDot extends StatelessWidget {
  const _MilestoneDot({required this.reached});

  final bool reached;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: reached ? AppColors.primary : AppColors.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(
          color: reached ? AppColors.primary : AppColors.outline,
          width: 1.5,
        ),
      ),
      child: reached
          ? const Icon(
              Icons.check_rounded,
              size: 11,
              color: AppColors.onPrimary,
            )
          : null,
    );
  }
}

// ── Last Session Row ──────────────────────────────────────────────────────────

class _LastSessionRow extends StatelessWidget {
  const _LastSessionRow({required this.dateKey, required this.l10n});

  final String dateKey;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parsed = DateTime.tryParse(dateKey);
    final dateLabel = parsed == null
        ? dateKey
        : DateFormat.yMMMd(
            Localizations.localeOf(context).toString(),
          ).format(parsed);

    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 13,
          color: AppColors.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          l10n.statsLastSession(dateLabel),
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ── Session history shortcut ─────────────────────────────────────────────────

class _SessionHistoryRow extends StatelessWidget {
  const _SessionHistoryRow({required this.onTap, required this.l10n});

  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: AppColors.tertiary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsSessionHistoryTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.statsSessionHistorySubtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.onSurfaceSubtle,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── ④ Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.self_improvement_rounded,
              size: 32,
              color: AppColors.onSurfaceSubtle,
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.statsEmptyTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            l10n.statsEmptyBody,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
