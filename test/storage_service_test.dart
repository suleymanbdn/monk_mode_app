import 'package:flutter_test/flutter_test.dart';
import 'package:monk_mode/models/app_language.dart';
import 'package:monk_mode/services/storage_service.dart';
import 'package:monk_mode/utils/time_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('first completed session sets streak to 1 and logs minutes', () async {
    final storage = StorageService();
    await storage.init();
    final stats = await storage.updateAfterCompletedSession(25);
    expect(stats.currentStreak, 1);
    expect(stats.longestStreak, 1);
    expect(stats.totalSessions, 1);
    expect(stats.totalMinutes, 25);
    expect(stats.dopamineScore, greaterThan(0));
  });

  test('second session same day does not increment streak', () async {
    SharedPreferences.setMockInitialValues({
      'streak_count': 3,
      'longest_streak': 3,
      'last_session_date': TimeUtils.todayKey,
      'total_sessions': 5,
      'total_focus_minutes': 100,
      'dopamine_score': 40,
    });
    final storage = StorageService();
    await storage.init();
    final stats = await storage.updateAfterCompletedSession(30);
    expect(stats.currentStreak, 3);
    expect(stats.totalSessions, 6);
  });

  test('session after yesterday increments streak', () async {
    SharedPreferences.setMockInitialValues({
      'streak_count': 2,
      'longest_streak': 2,
      'last_session_date': TimeUtils.yesterdayKey,
      'total_sessions': 2,
      'total_focus_minutes': 60,
      'dopamine_score': 20,
    });
    final storage = StorageService();
    await storage.init();
    final stats = await storage.updateAfterCompletedSession(15);
    expect(stats.currentStreak, 3);
    expect(stats.longestStreak, 3);
  });

  test('resetAllData clears duration presets key', () async {
    SharedPreferences.setMockInitialValues({
      'streak_count': 1,
      'duration_presets_minutes': '[5,10,15]',
    });
    final storage = StorageService();
    await storage.init();
    await storage.resetAllData();
    final p = await SharedPreferences.getInstance();
    expect(p.getString('duration_presets_minutes'), isNull);
    expect(p.getInt('streak_count'), isNull);
  });

  test('dopamine score tiers from completed session length', () async {
    Future<int> scoreAfterMinutes(int m) async {
      SharedPreferences.setMockInitialValues({});
      final s = StorageService();
      await s.init();
      final stats = await s.updateAfterCompletedSession(m);
      return stats.dopamineScore;
    }

    expect(await scoreAfterMinutes(10), 3);
    expect(await scoreAfterMinutes(45), 5);
    expect(await scoreAfterMinutes(60), 10);
    expect(await scoreAfterMinutes(200), 20);
  });

  test('app UI language defaults to English', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();
    expect(storage.loadAppLanguage(), AppLanguage.en);
  });

  test('saveAppLanguage persists Turkish', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();
    await storage.saveAppLanguage(AppLanguage.tr);
    expect(storage.loadAppLanguage(), AppLanguage.tr);
  });
}
