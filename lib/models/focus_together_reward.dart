import 'app_stats.dart';

/// Outcome of applying Focus Together to Monk Mode stats (streak, clarity, milestones).
class FocusTogetherReward {
  const FocusTogetherReward({
    required this.naturalComplete,
    required this.dopamineDeltaTotal,
    required this.togetherBonus,
    required this.sessionTierPoints,
    required this.newStats,
    required this.togetherSessionsAllTime,
    this.milestoneTitle,
    this.milestoneSubtitle,
    this.nextCircleProgress,
  });

  final bool naturalComplete;

  /// Total clarity change from this wrap-up (session rules + decay + squad bonus, or consolation only).
  final int dopamineDeltaTotal;

  /// Extra clarity for finishing alongside others (natural complete only).
  final int togetherBonus;

  /// Base tier points for session length (before squad bonus); natural complete only.
  final int sessionTierPoints;

  final AppStats newStats;

  /// Lifetime Focus Together sessions that counted toward stats (natural complete).
  final int togetherSessionsAllTime;

  final String? milestoneTitle;
  final String? milestoneSubtitle;

  /// Progress toward the next circle segment after this wrap-up (UI uses [FocusTogetherCircleProgress] + l10n).
  final double? nextCircleProgress;
}
