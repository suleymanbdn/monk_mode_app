import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_language.dart';
import '../models/app_stats.dart';
import '../models/focus_together_circle_progress.dart';
import '../models/focus_together_milestones.dart';
import '../models/focus_together_reward.dart';
import '../models/session_log_entry.dart';
import '../utils/time_utils.dart';

/// Local persistence layer for all user stats.
///
/// Uses SharedPreferences — each field has its own named key so values can
/// be read, written, or cleared independently without touching the rest.
///
/// Stored keys (SharedPreferences):
///   streak_count        int — current day streak
///   longest_streak      int — all-time best streak
///   last_session_date   str — YYYY-MM-DD of the last completed session
///   total_sessions      int — cumulative completed sessions
///   total_focus_minutes int — cumulative focus time in minutes
///   dopamine_score      int — accumulated clarity score (0–100)
class StorageService {
  // ── Storage keys ──────────────────────────────────────────────────────────

  static const _kStreak = 'streak_count';
  static const _kLongestStreak = 'longest_streak';
  static const _kLastDate = 'last_session_date';
  static const _kTotalSessions = 'total_sessions';
  static const _kTotalMinutes = 'total_focus_minutes';
  static const _kDopamineScore = 'dopamine_score';
  static const _kSessionLog = 'session_log';
  static const _kDurationPresets = 'duration_presets_minutes';

  /// Natural-complete Focus Together sessions (for milestones).
  static const _kTogetherTotal = 'focus_together_natural_completions';

  static const _maxLogEntries = 100;

  /// Minutes the user can assign to the three Monk Mode chips (Settings).
  static const List<int> allowedFocusMinutes = [
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    55,
    60,
    75,
    90,
    105,
    120,
    150,
    180,
  ];

  static const List<int> defaultDurationPresets = [15, 30, 60];

  // Legacy key — kept only for one-time migration from old JSON-blob format.
  static const _kLegacyBlob = 'app_stats';

  /// `tr` when user chose Turkish; absent or other → English (default UI language).
  static const _kAppLanguage = 'app_language';

  // ── Initialisation ────────────────────────────────────────────────────────

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _migrateIfNeeded();
  }

  // ── App UI language (default: English; Turkish is opt-in in Settings) ─────

  /// Defaults to [AppLanguage.en] when unset.
  AppLanguage loadAppLanguage() {
    final raw = _prefs.getString(_kAppLanguage);
    return raw == 'tr' ? AppLanguage.tr : AppLanguage.en;
  }

  Future<void> saveAppLanguage(AppLanguage language) async {
    if (language == AppLanguage.tr) {
      await _prefs.setString(_kAppLanguage, 'tr');
    } else {
      await _prefs.remove(_kAppLanguage);
    }
  }

  // ── Focus duration presets (three chips on Monk Mode) ─────────────────────

  /// Three distinct lengths in minutes, left-to-right order on the timer screen.
  List<int> loadDurationPresets() {
    final raw = _prefs.getString(_kDurationPresets);
    if (raw == null || raw.isEmpty) {
      return List<int>.from(defaultDurationPresets);
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final parsed = decoded.map((e) => (e as num).toInt()).toList();
      return _coerceDurationPresets(parsed);
    } catch (_) {
      return List<int>.from(defaultDurationPresets);
    }
  }

  Future<void> saveDurationPresets(List<int> minutes) async {
    final coerced = _coerceDurationPresets(minutes);
    await _prefs.setString(_kDurationPresets, jsonEncode(coerced));
  }

  List<int> _coerceDurationPresets(List<int> input) {
    if (input.length != 3) return List<int>.from(defaultDurationPresets);
    final out = <int>[];
    for (final m in input) {
      if (!allowedFocusMinutes.contains(m)) {
        return List<int>.from(defaultDurationPresets);
      }
      out.add(m);
    }
    if (out.toSet().length != 3) return List<int>.from(defaultDurationPresets);
    return out;
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  /// Returns the current [AppStats] from local storage.
  /// Any field that has never been written returns a safe default (0 / null).
  AppStats loadAppStats() {
    final lastDate = _prefs.getString(_kLastDate);

    return AppStats(
      currentStreak: _prefs.getInt(_kStreak) ?? 0,
      longestStreak: _prefs.getInt(_kLongestStreak) ?? 0,
      lastSessionDate: lastDate?.isEmpty ?? true ? null : lastDate,
      totalSessions: _prefs.getInt(_kTotalSessions) ?? 0,
      totalMinutes: _prefs.getInt(_kTotalMinutes) ?? 0,
      dopamineScore: _prefs.getInt(_kDopamineScore) ?? 0,
    );
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  /// Persists every field of [stats] to its own key.
  /// All writes run in parallel for speed.
  Future<void> saveAppStats(AppStats stats) async {
    final writes = <Future<bool>>[
      _prefs.setInt(_kStreak, stats.currentStreak),
      _prefs.setInt(_kLongestStreak, stats.longestStreak),
      _prefs.setInt(_kTotalSessions, stats.totalSessions),
      _prefs.setInt(_kTotalMinutes, stats.totalMinutes),
      _prefs.setInt(_kDopamineScore, stats.dopamineScore),
    ];

    if (stats.lastSessionDate != null) {
      writes.add(_prefs.setString(_kLastDate, stats.lastSessionDate!));
    }

    await Future.wait(writes);
  }

  /// Raw natural-completion count used for milestone progress and cloud backup.
  int loadTogetherTotal() => _prefs.getInt(_kTogetherTotal) ?? 0;

  /// Replaces all local stats with [stats] and [togetherTotal].
  ///
  /// Used exclusively during cloud restore so the user's backed-up data
  /// overwrites whatever is currently stored on the device.
  Future<void> restoreFromCloudStats(
    AppStats stats, {
    required int togetherTotal,
  }) async {
    await saveAppStats(stats);
    await _prefs.setInt(_kTogetherTotal, togetherTotal);
  }

  /// Personal progress toward the next Focus Together milestone (local count only).
  FocusTogetherCircleProgress loadFocusTogetherCircleProgress() {
    final count = _prefs.getInt(_kTogetherTotal) ?? 0;
    final tiers = kFocusTogetherMilestoneTiers;
    final maxAt = tiers.last.at;

    if (count >= maxAt) {
      return FocusTogetherCircleProgress(
        naturalCompletions: count,
        prevThreshold: maxAt,
        nextTier: null,
        sessionsUntilNext: 0,
        segmentProgress: 1,
        allNamedTiersComplete: true,
      );
    }

    var prev = 0;
    FocusTogetherMilestoneTier? nextTier;
    for (final t in tiers) {
      if (t.at <= count) {
        prev = t.at;
      } else {
        nextTier = t;
        break;
      }
    }

    final span = nextTier!.at - prev;
    final done = count - prev;
    final seg = span > 0 ? done / span : 0.0;

    return FocusTogetherCircleProgress(
      naturalCompletions: count,
      prevThreshold: prev,
      nextTier: nextTier,
      sessionsUntilNext: nextTier.at - count,
      segmentProgress: seg.clamp(0.0, 1.0),
      allNamedTiersComplete: false,
    );
  }

  (String?, String?) _togetherMilestoneUnlock(int total) {
    for (final t in kFocusTogetherMilestoneTiers) {
      if (t.at == total) {
        return (t.unlockTitle, t.unlockSubtitle);
      }
    }
    return (null, null);
  }

  /// Applies Monk Mode stats after Focus Together: streak + minutes on natural complete,
  /// squad clarity bonus, milestones; early exit gets small consolation clarity only.
  Future<FocusTogetherReward> applyFocusTogetherOutcome({
    required int durationMinutes,
    required bool naturalComplete,
    required int peersWhoCompleted,
  }) async {
    if (!naturalComplete) {
      final before = loadAppStats();
      const consolation = 2;
      final next = before.copyWith(
        dopamineScore: (before.dopamineScore + consolation).clamp(0, 100),
      );
      await saveAppStats(next);
      final circle = loadFocusTogetherCircleProgress();
      return FocusTogetherReward(
        naturalComplete: false,
        dopamineDeltaTotal: next.dopamineScore - before.dopamineScore,
        togetherBonus: 0,
        sessionTierPoints: 0,
        newStats: next,
        togetherSessionsAllTime: _prefs.getInt(_kTogetherTotal) ?? 0,
        nextCircleProgress: circle.segmentProgress,
      );
    }

    final before = loadAppStats();
    final tierPoints = _sessionIncrement(durationMinutes);
    final peerClamped = peersWhoCompleted.clamp(0, 8);
    final togetherBonus = (peerClamped * 2).clamp(0, 8);

    final afterMain = await updateAfterCompletedSession(durationMinutes);

    final afterBonus = afterMain.copyWith(
      dopamineScore: (afterMain.dopamineScore + togetherBonus).clamp(0, 100),
    );
    await saveAppStats(afterBonus);

    final tt = (_prefs.getInt(_kTogetherTotal) ?? 0) + 1;
    await _prefs.setInt(_kTogetherTotal, tt);

    final milestone = _togetherMilestoneUnlock(tt);
    final circle = loadFocusTogetherCircleProgress();

    return FocusTogetherReward(
      naturalComplete: true,
      dopamineDeltaTotal: afterBonus.dopamineScore - before.dopamineScore,
      togetherBonus: togetherBonus,
      sessionTierPoints: tierPoints,
      newStats: afterBonus,
      togetherSessionsAllTime: tt,
      milestoneTitle: milestone.$1,
      milestoneSubtitle: milestone.$2,
      nextCircleProgress: circle.segmentProgress,
    );
  }

  // ── Session completion ─────────────────────────────────────────────────────
  //
  // Streak rules:
  //   First-ever session       → streak = 1
  //   Same day as last session → streak unchanged (one per day counts)
  //   Day after last session   → streak + 1
  //   Two or more days missed  → streak resets to 1
  //
  // Dopamine score:
  //   < 30 min → +3  pts   30 min → +5   60 min → +10   180 min → +20
  //   Missed days → –2 per day, capped at –10, applied before the gain

  /// Calculates updated stats after a completed focus session, saves them,
  /// and returns the new [AppStats] so the UI can refresh immediately.
  Future<AppStats> updateAfterCompletedSession(int durationMinutes) async {
    final current = loadAppStats();
    final newStreak = _calculateStreak(current);
    final newLongest = newStreak > current.longestStreak
        ? newStreak
        : current.longestStreak;

    // Apply any decay for missed days, then add the session gain.
    final scoreAfterDecay = (current.dopamineScore - _decayPenalty(current))
        .clamp(0, 100);
    final newScore = (scoreAfterDecay + _sessionIncrement(durationMinutes))
        .clamp(0, 100);

    final updated = current.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest,
      totalSessions: current.totalSessions + 1,
      totalMinutes: current.totalMinutes + durationMinutes,
      lastSessionDate: TimeUtils.todayKey,
      dopamineScore: newScore,
    );

    await saveAppStats(updated);
    await _appendSessionLog(durationMinutes);
    return updated;
  }

  // ── Session history (local list, newest first) ────────────────────────────

  List<SessionLogEntry> loadSessionLog() {
    final raw = _prefs.getString(_kSessionLog);
    if (raw == null || raw.isEmpty) return [];

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => SessionLogEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _appendSessionLog(int durationMinutes) async {
    final entry = SessionLogEntry(
      dateKey: TimeUtils.todayKey,
      durationMinutes: durationMinutes,
      completedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    final next = [entry, ...loadSessionLog()];
    final capped = next.length > _maxLogEntries
        ? next.sublist(0, _maxLogEntries)
        : next;
    await _prefs.setString(
      _kSessionLog,
      jsonEncode(capped.map((e) => e.toJson()).toList()),
    );
  }

  /// Clears all stats, session log, and legacy keys. Cannot be undone.
  Future<void> resetAllData() async {
    await Future.wait([
      _prefs.remove(_kStreak),
      _prefs.remove(_kLongestStreak),
      _prefs.remove(_kLastDate),
      _prefs.remove(_kTotalSessions),
      _prefs.remove(_kTotalMinutes),
      _prefs.remove(_kDopamineScore),
      _prefs.remove(_kSessionLog),
      _prefs.remove(_kTogetherTotal),
      _prefs.remove(_kDurationPresets),
      _prefs.remove(_kLegacyBlob),
    ]);
  }

  // ── Scoring helpers ───────────────────────────────────────────────────────

  /// Points earned for completing a session of [durationMinutes].
  ///
  ///   &lt; 30 min → +3   (short focus)
  ///   30 min → +5   (small gain — good start)
  ///   60 min → +10  (medium gain — solid session)
  ///  180 min → +20  (large gain — deep focus)
  static int _sessionIncrement(int durationMinutes) {
    if (durationMinutes >= 180) return 20;
    if (durationMinutes >= 60) return 10;
    if (durationMinutes >= 30) return 5;
    return 3;
  }

  /// Points to deduct when returning after one or more missed days.
  ///
  /// Only fires when the streak is already broken (isStreakAlive = false).
  /// 2 points per missed day, capped at 10 so the score never collapses.
  static int _decayPenalty(AppStats stats) {
    if (stats.lastSessionDate == null) return 0;
    if (stats.isStreakAlive) return 0;

    final last = DateTime.tryParse(stats.lastSessionDate!);
    if (last == null) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(last.year, last.month, last.day);
    // inDays - 1: yesterday counts as 0 missed days; 2 days ago = 1 missed day.
    final daysMissed = today.difference(lastDay).inDays - 1;
    if (daysMissed <= 0) return 0;

    return (daysMissed * 2).clamp(0, 10);
  }

  // ── Streak helper ─────────────────────────────────────────────────────────

  /// Pure function — determines the new streak value from existing stats.
  static int _calculateStreak(AppStats stats) {
    if (stats.lastSessionDate == null) return 1;
    if (stats.completedToday) return stats.effectiveStreak;
    if (stats.lastSessionDate == TimeUtils.yesterdayKey) {
      return stats.effectiveStreak + 1;
    }
    return 1;
  }

  // ── Migration ─────────────────────────────────────────────────────────────

  /// One-time migration from the old single JSON-blob format.
  /// Runs once on init, then removes the old key so it never runs again.
  Future<void> _migrateIfNeeded() async {
    final blob = _prefs.getString(_kLegacyBlob);
    if (blob == null) return;

    try {
      final old = AppStats.fromJson(jsonDecode(blob) as Map<String, dynamic>);
      await saveAppStats(old);
    } catch (_) {
      // Corrupt blob — start fresh rather than crash.
    } finally {
      await _prefs.remove(_kLegacyBlob);
    }
  }
}
