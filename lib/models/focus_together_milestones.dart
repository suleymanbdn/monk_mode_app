/// Shared Focus Together circle milestones (natural completions only).
/// Copy is honest: no fake global stats — only your count and what comes next.
class FocusTogetherMilestoneTier {
  const FocusTogetherMilestoneTier({
    required this.at,
    required this.unlockTitle,
    required this.unlockSubtitle,
    required this.chaseLine,
  });

  /// Total natural completions when this unlocks.
  final int at;

  /// Shown on session summary when you hit this number.
  final String unlockTitle;
  final String unlockSubtitle;

  /// Shown on home / hub while you are working toward this threshold.
  final String chaseLine;
}

/// Ordered thresholds — keep sorted by [at].
const List<FocusTogetherMilestoneTier> kFocusTogetherMilestoneTiers = [
  FocusTogetherMilestoneTier(
    at: 1,
    unlockTitle: 'First light',
    unlockSubtitle:
        'You finished a full session with others. That is the hardest step.',
    chaseLine: 'Your first circle badge is one natural finish away.',
  ),
  FocusTogetherMilestoneTier(
    at: 3,
    unlockTitle: 'Momentum',
    unlockSubtitle:
        'Three shared finishes — your group is turning focus into a habit.',
    chaseLine: 'Three finishes is where a group habit usually sticks.',
  ),
  FocusTogetherMilestoneTier(
    at: 5,
    unlockTitle: 'Squad rhythm',
    unlockSubtitle:
        'Five times you all stayed until the end. Consistency beats intensity.',
    chaseLine: 'Five sessions is when shared focus starts to feel normal.',
  ),
  FocusTogetherMilestoneTier(
    at: 10,
    unlockTitle: 'Circle strength',
    unlockSubtitle:
        'Ten shared wins. Most people never stack this — you are building something real.',
    chaseLine: 'Double digits is worth protecting — one room at a time.',
  ),
  FocusTogetherMilestoneTier(
    at: 15,
    unlockTitle: 'Deep bench',
    unlockSubtitle:
        'Fifteen natural finishes. Your circle shows up when it counts.',
    chaseLine: 'You are past the novelty phase — keep the ritual alive.',
  ),
  FocusTogetherMilestoneTier(
    at: 25,
    unlockTitle: 'Focus anchor',
    unlockSubtitle:
        'Twenty-five shared sessions. That is discipline most people never stack.',
    chaseLine: 'The anchor badge is for groups that do not quit.',
  ),
  FocusTogetherMilestoneTier(
    at: 50,
    unlockTitle: 'Circle legend',
    unlockSubtitle:
        'Fifty natural finishes together. Save this screen — you earned it.',
    chaseLine: 'After this, the win is the habit itself.',
  ),
];
