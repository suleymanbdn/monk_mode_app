import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kSnoozeKey = 'play_update_snooze_until_ms';

/// Google Play native in-app update check (Android only).
///
/// Calls Play Core directly — no Firestore, no token, no version file.
/// Always in sync with the actual store build.
class PlayUpdateService {
  PlayUpdateService(this._prefs);

  final SharedPreferences _prefs;

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  bool _isSnoozed() {
    final until = _prefs.getInt(_kSnoozeKey);
    if (until == null) return false;
    return DateTime.now().millisecondsSinceEpoch < until;
  }

  Future<void> snooze({Duration duration = const Duration(days: 1)}) async {
    final until = DateTime.now().add(duration).millisecondsSinceEpoch;
    await _prefs.setInt(_kSnoozeKey, until);
  }

  /// Returns Play update info, or null if:
  ///   • not Android
  ///   • user snoozed the prompt
  ///   • running on a debug/sideloaded build (Play Core throws)
  Future<AppUpdateInfo?> fetchUpdateInfo() async {
    if (!_isAndroid) return null;
    if (_isSnoozed()) return null;
    try {
      return await InAppUpdate.checkForUpdate();
    } catch (_) {
      return null;
    }
  }

  bool isUpdateAvailable(AppUpdateInfo? info) {
    if (info == null) return false;
    return info.updateAvailability == UpdateAvailability.updateAvailable;
  }

  /// Triggers the Play immediate update flow (blocks the app until updated).
  Future<AppUpdateResult> performImmediateUpdate() =>
      InAppUpdate.performImmediateUpdate();

  /// Triggers the Play flexible update flow (downloads in background).
  Future<AppUpdateResult> startFlexibleUpdate() =>
      InAppUpdate.startFlexibleUpdate();
}
