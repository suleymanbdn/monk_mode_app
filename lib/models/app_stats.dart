import '../utils/time_utils.dart';

class AppStats {
  const AppStats({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalSessions = 0,
    this.totalMinutes = 0,
    this.dopamineScore = 0,
    this.lastSessionDate,
  });

  final int currentStreak;
  final int longestStreak;
  final int totalSessions;
  final int totalMinutes;

  /// Accumulated clarity score from 0 to 100.
  ///
  /// Stored (not computed) so it grows incrementally with each session
  /// and can apply mild decay for missed days without collapsing on streak
  /// breaks. Updated exclusively by StorageService.updateAfterCompletedSession.
  final int dopamineScore;

  /// The date (YYYY-MM-DD) of the most recent completed session.
  /// Null means no session has ever been completed.
  final String? lastSessionDate;

  // ── Streak helpers ────────────────────────────────────────────────────────
  //
  // A streak is "alive" if the user completed a session either today or
  // yesterday. If more than one day has passed without a session, the streak
  // is considered broken, even if a positive value is stored.
  //
  // Always read effectiveStreak instead of currentStreak directly.

  bool get completedToday => lastSessionDate == TimeUtils.todayKey;

  bool get isStreakAlive {
    if (lastSessionDate == null) return false;
    return lastSessionDate == TimeUtils.todayKey ||
        lastSessionDate == TimeUtils.yesterdayKey;
  }

  /// Returns 0 if a day has been missed, regardless of what is stored.
  int get effectiveStreak => isStreakAlive ? currentStreak : 0;

  // ── Serialisation ─────────────────────────────────────────────────────────

  factory AppStats.fromJson(Map<String, dynamic> json) {
    int jInt(String k) {
      final v = json[k];
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return 0;
    }

    return AppStats(
      currentStreak: jInt('currentStreak'),
      longestStreak: jInt('longestStreak'),
      totalSessions: jInt('totalSessions'),
      totalMinutes: jInt('totalMinutes'),
      dopamineScore: jInt('dopamineScore'),
      lastSessionDate: json['lastSessionDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'totalSessions': totalSessions,
    'totalMinutes': totalMinutes,
    'dopamineScore': dopamineScore,
    'lastSessionDate': lastSessionDate,
  };

  AppStats copyWith({
    int? currentStreak,
    int? longestStreak,
    int? totalSessions,
    int? totalMinutes,
    int? dopamineScore,
    String? lastSessionDate,
  }) {
    return AppStats(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalSessions: totalSessions ?? this.totalSessions,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      dopamineScore: dopamineScore ?? this.dopamineScore,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
    );
  }
}
