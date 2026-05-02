import 'focus_together_milestones.dart';

/// Personal progress toward the next Focus Together milestone (local data only).
class FocusTogetherCircleProgress {
  const FocusTogetherCircleProgress({
    required this.naturalCompletions,
    required this.prevThreshold,
    required this.nextTier,
    required this.sessionsUntilNext,
    required this.segmentProgress,
    required this.allNamedTiersComplete,
  });

  final int naturalCompletions;

  /// Last milestone at or below [naturalCompletions] (0 if none yet).
  final int prevThreshold;

  /// Next tier to unlock, or null if past every named tier.
  final FocusTogetherMilestoneTier? nextTier;

  /// Sessions still needed for [nextTier], or 0 if none.
  final int sessionsUntilNext;

  /// Progress within the segment (prev → next], for a thin bar.
  final double segmentProgress;

  final bool allNamedTiersComplete;
}
