import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'focus_room_runtime.dart';

/// Display name in SharedPreferences; Focus Together user id is [User.uid] when
/// Firebase Auth (anonymous) is active, otherwise a persisted local id.
abstract final class FocusRoomIdentity {
  static const _kUserId = 'focus_together_user_id';
  static const _kDisplayName = 'focus_together_display_name';

  /// Persists the name shown to others (max 20 chars). Empty strings are ignored.
  static Future<void> saveDisplayName(String raw) async {
    var t = raw.trim();
    if (t.isEmpty) return;
    if (t.length > 20) t = t.substring(0, 20);
    final p = await SharedPreferences.getInstance();
    await p.setString(_kDisplayName, t);
  }

  /// Clears stored guest id and display name (not Firebase Auth).
  static Future<void> clearLocalFocusIdentity() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kUserId);
    await p.remove(_kDisplayName);
  }

  /// Ensures an anonymous Firebase user exists when cloud Focus Together is on.
  static Future<void> ensureSignedInForCloud() async {
    if (!focusRoomCloudSyncEnabled) return;
    if (Firebase.apps.isEmpty) return;
    try {
      if (FirebaseAuth.instance.currentUser != null) return;
      await FirebaseAuth.instance.signInAnonymously();
    } catch (_) {}
  }

  /// New anonymous Firebase user when cloud sync is on (after local prefs cleared).
  static Future<void> rotateAnonymousAuthIfCloud() async {
    if (!focusRoomCloudSyncEnabled) return;
    if (Firebase.apps.isEmpty) return;
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.signInAnonymously();
    } catch (_) {}
  }

  static Future<({String userId, String displayName})> loadOrCreate() async {
    final p = await SharedPreferences.getInstance();

    final userId = await _resolveUserId(p);

    var displayName = p.getString(_kDisplayName);
    if (displayName == null || displayName.isEmpty) {
      displayName = _newDisplayName();
      await p.setString(_kDisplayName, displayName);
    }
    return (userId: userId, displayName: displayName);
  }

  static Future<String> _resolveUserId(SharedPreferences p) async {
    if (Firebase.apps.isNotEmpty) {
      final u = FirebaseAuth.instance.currentUser;
      if (u != null) return u.uid;
    }
    var userId = p.getString(_kUserId);
    if (userId == null || userId.isEmpty) {
      userId = _newUserId();
      await p.setString(_kUserId, userId);
    }
    return userId;
  }

  static String _newUserId() {
    final r = Random.secure();
    final hex = List.generate(
      16,
      (_) => r.nextInt(16).toRadixString(16),
    ).join();
    return 'u_$hex';
  }

  static String _newDisplayName() {
    final n = Random.secure().nextInt(9000) + 1000;
    return 'Guest $n';
  }
}
