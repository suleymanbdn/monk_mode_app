import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/app_formatting.dart';
import '../../../l10n/focus_together_circle_l10n.dart';
import '../../../models/focus_together_reward.dart';
import '../../../widgets/app_storage_scope.dart';
import '../../../widgets/primary_button.dart';
import '../focus_room_navigation.dart';
import '../models/focus_room_models.dart';
import '../widgets/fr_card.dart';
import '../widgets/fr_focus_states.dart';
import '../widgets/fr_section_header.dart';
import 'focus_room_home_screen.dart';

class SessionSummaryScreen extends StatefulWidget {
  const SessionSummaryScreen({super.key, required this.summary});

  final FocusSessionSummary summary;

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> {
  bool _visible = false;
  FocusTogetherReward? _reward;
  bool _rewardLoadStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
      unawaited(_loadRewards());
    });
  }

  Future<void> _loadRewards() async {
    if (_rewardLoadStarted) return;
    _rewardLoadStarted = true;
    final storage = AppStorageScope.maybeOf(context);
    if (storage == null || !mounted) return;

    final s = widget.summary;
    final natural = s.endKind == SessionEndKind.naturalComplete;
    final peers = natural ? (s.completedNames.length - 1).clamp(0, 99) : 0;

    final reward = await storage.applyFocusTogetherOutcome(
      durationMinutes: s.durationMinutes,
      naturalComplete: natural,
      peersWhoCompleted: peers,
    );
    if (mounted) setState(() => _reward = reward);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final s = widget.summary;
    final early = s.endKind == SessionEndKind.localLeftEarly;

    final headline = early
        ? l10n.summaryHeadlineEarly
        : l10n.summaryHeadlineDone;
    final sub = early ? l10n.summarySubEarly : l10n.summarySubNatural;

    return Scaffold(
      appBar: AppBar(
        title: Text(early ? l10n.summaryAppBarEarly : l10n.summaryAppBarDone),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            offset: _visible ? Offset.zero : const Offset(0, 0.02),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              children: [
                const SizedBox(height: 8),
                Icon(
                  early ? Icons.timer_off_rounded : Icons.check_circle_rounded,
                  size: 56,
                  color: early ? AppColors.onSurfaceVariant : AppColors.success,
                ),
                const SizedBox(height: 20),
                Text(
                  headline,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  sub,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.summaryEndedAt(s.endedAtHm),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_reward != null) ...[
                  const SizedBox(height: 24),
                  _FocusTogetherRewardCard(
                    reward: _reward!,
                    durationMinutes: s.durationMinutes,
                    l10n: l10n,
                  ),
                ],
                const SizedBox(height: 28),
                FrCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.roomName.isEmpty
                            ? l10n.summaryDefaultRoom
                            : s.roomName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.formatSessionMinutes(s.durationMinutes),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FrSectionHeader(l10n.summaryCompleted),
                const SizedBox(height: 12),
                FrCard(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: s.completedNames.isEmpty
                      ? FrEmptyHint(
                          title: l10n.summaryCompletedEmptyTitle,
                          subtitle: l10n.summaryCompletedEmptySubtitle,
                          icon: Icons.hourglass_empty_rounded,
                        )
                      : Column(
                          children: [
                            for (final name in s.completedNames)
                              _NameRow(name: name, done: true),
                          ],
                        ),
                ),
                if (s.skippedNames.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  FrSectionHeader(l10n.summaryDidNotFinish),
                  const SizedBox(height: 12),
                  FrCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Column(
                      children: [
                        for (final name in s.skippedNames)
                          _NameRow(name: name, done: false),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                PrimaryButton(
                  label: l10n.summaryBackMonk,
                  icon: Icons.home_rounded,
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: l10n.summaryFocusAgain,
                  outlined: true,
                  onPressed: () {
                    final nav = Navigator.of(context);
                    nav.popUntil((route) => route.isFirst);
                    nav.push<void>(
                      focusRoomFadeRoute(const FocusRoomHomeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusTogetherRewardCard extends StatelessWidget {
  const _FocusTogetherRewardCard({
    required this.reward,
    required this.durationMinutes,
    required this.l10n,
  });

  final FocusTogetherReward reward;
  final int durationMinutes;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = reward;
    final storage = AppStorageScope.maybeOf(context);
    final circle = storage?.loadFocusTogetherCircleProgress();

    return FrCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                r.naturalComplete
                    ? Icons.military_tech_rounded
                    : Icons.favorite_outline_rounded,
                color: r.naturalComplete
                    ? AppColors.primary
                    : AppColors.tertiary,
                size: 26,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  r.naturalComplete
                      ? l10n.summaryRewardsNatural
                      : l10n.summaryRewardsEarly,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (r.naturalComplete) ...[
            _RewardLine(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.primary,
              text: r.newStats.effectiveStreak == 1
                  ? l10n.summaryStreakLineOne
                  : l10n.summaryStreakLineMany(r.newStats.effectiveStreak),
            ),
            const SizedBox(height: 10),
            _RewardLine(
              icon: Icons.bubble_chart_rounded,
              iconColor: AppColors.tertiary,
              text: l10n.summaryClarityLine(
                r.dopamineDeltaTotal,
                l10n.formatSessionMinutes(durationMinutes),
              ),
            ),
            if (r.togetherBonus > 0)
              Padding(
                padding: const EdgeInsets.only(left: 34, top: 6),
                child: Text(
                  l10n.summarySquadBonus(r.togetherBonus),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              l10n.summaryClarityNow(r.newStats.dopamineScore),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceSubtle,
              ),
            ),
          ] else ...[
            _RewardLine(
              icon: Icons.bubble_chart_rounded,
              iconColor: AppColors.tertiary,
              text: l10n.summaryEarlyClarityLine(r.dopamineDeltaTotal),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.summaryEarlyHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
          if (r.milestoneTitle != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FocusTogetherMilestoneL10n.title(
                          l10n,
                          r.togetherSessionsAllTime,
                        ) ??
                        r.milestoneTitle!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  if (r.milestoneSubtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      FocusTogetherMilestoneL10n.subtitle(
                            l10n,
                            r.togetherSessionsAllTime,
                          ) ??
                          r.milestoneSubtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (r.nextCircleProgress != null && circle != null) ...[
            const SizedBox(height: 18),
            Text(
              l10n.summaryNextReturn,
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 0.6,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              circle.localizedHeadline(l10n),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              circle.localizedSubline(l10n),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: r.nextCircleProgress!.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppColors.surfaceContainerHigh,
                color: AppColors.tertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardLine extends StatelessWidget {
  const _RewardLine({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
          ),
        ),
      ],
    );
  }
}

class _NameRow extends StatelessWidget {
  const _NameRow({required this.name, required this.done});

  final String name;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_rounded : Icons.remove_circle_outline_rounded,
            size: 20,
            color: done ? AppColors.success : AppColors.onSurfaceSubtle,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
