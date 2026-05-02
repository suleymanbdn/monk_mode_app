import '../models/app_stats.dart';

/// Parsers and limits aligned with [firestore.rules] for `users/{uid}` backup.
abstract final class FirestoreValueUtils {
  static const int kMaxStreak = 50_000;
  static const int kMaxTotalSessions = 1_000_000;
  static const int kMaxTotalMinutes =
      100_000_000; // far above any realistic use
  static const int kMaxDopamine = 1_000; // rules allow headroom; UI is 0–100
  static const int kMaxTogether = 1_000_000;

  static int readInt(Object? v, {int min = 0, int max = 1 << 30}) {
    if (v == null) return min;
    if (v is int) return v.clamp(min, max);
    if (v is num) return v.toInt().clamp(min, max);
    return min;
  }

  static String? readDateKey(Object? v) {
    if (v == null) return null;
    if (v is! String) return null;
    final s = v.trim();
    if (s.length != 10) return null;
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(s)) return null;
    return s;
  }

  /// [AppStats] safe for writing to / reading from Firestore (no throw on [num]).
  static AppStats sanitizeAppStatsMap(Map<String, dynamic> m) {
    return AppStats(
      currentStreak: readInt(m['currentStreak'], min: 0, max: kMaxStreak),
      longestStreak: readInt(m['longestStreak'], min: 0, max: kMaxStreak),
      totalSessions: readInt(
        m['totalSessions'],
        min: 0,
        max: kMaxTotalSessions,
      ),
      totalMinutes: readInt(m['totalMinutes'], min: 0, max: kMaxTotalMinutes),
      dopamineScore: readInt(m['dopamineScore'], min: 0, max: kMaxDopamine),
      lastSessionDate: readDateKey(m['lastSessionDate']),
    );
  }

  static int sanitizeTogetherTotal(Object? v) =>
      readInt(v, min: 0, max: kMaxTogether);
}
