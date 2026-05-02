import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/version_compare.dart';

/// Result of checking Firestore [app_config] for a newer store build.
class AppUpdateCheckResult {
  const AppUpdateCheckResult._({
    required this.shouldPrompt,
    required this.forceUpdate,
    this.message,
    this.latestVersion = '',
    this.currentVersion = '',
    this.storeUrl = '',
  });

  const AppUpdateCheckResult.none()
    : shouldPrompt = false,
      forceUpdate = false,
      message = null,
      latestVersion = '',
      currentVersion = '',
      storeUrl = '';

  final bool shouldPrompt;
  final bool forceUpdate;
  final String? message;
  final String latestVersion;
  final String currentVersion;
  final String storeUrl;
}

/// Reads `app_config/{android|ios}` from Firestore (read-only for clients).
///
/// Fields:
/// - `latest_version` (string, required to prompt) e.g. "1.3.0"
/// - `min_supported_version` (string, optional) — below this → blocking screen
/// - `update_message` (string, optional)
/// - `store_url` (string, optional) — defaults to Play / App Store link
abstract final class AppUpdateChecker {
  static const _collection = 'app_config';
  static const _androidPackage = 'com.monkmode.monk_mode';
  static const _defaultPlayUrl =
      'https://play.google.com/store/apps/details?id=$_androidPackage';

  static String _docId() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return 'android';
    }
  }

  /// Returns true only for HTTPS URLs pointing to Play Store or App Store.
  /// Prevents open-redirect if the Firebase project config were ever tampered.
  static bool _isTrustedStoreUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (!uri.isScheme('https')) return false;
      const ok = {
        'play.google.com',
        'apps.apple.com',
        'itunes.apple.com', // legacy iOS store links
      };
      return ok.contains(uri.host);
    } catch (_) {
      return false;
    }
  }

  /// Android uses Play; iOS must set `store_url` in Firestore.
  static String _defaultStoreUrl() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return '';
    }
    return _defaultPlayUrl;
  }

  static Future<AppUpdateCheckResult> check() async {
    // Do not tie this to Focus Together: app_config is public-read and should run
    // whenever Firebase Core initialized (even if anonymous auth failed).
    if (Firebase.apps.isEmpty) {
      return const AppUpdateCheckResult.none();
    }

    try {
      return await _checkOnce();
    } catch (e, st) {
      if (kDebugMode) debugPrint('AppUpdateChecker: retry after error ($e)');
      if (kDebugMode) debugPrint('$st');
      await Future<void>.delayed(const Duration(milliseconds: 600));
      try {
        return await _checkOnce();
      } catch (e2, st2) {
        if (kDebugMode) debugPrint('AppUpdateChecker: skipped ($e2)');
        if (kDebugMode) debugPrint('$st2');
        return const AppUpdateCheckResult.none();
      }
    }
  }

  static Future<AppUpdateCheckResult> _checkOnce() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version.trim();

      final snap = await FirebaseFirestore.instance
          .collection(_collection)
          .doc(_docId())
          .get();

      if (!snap.exists) {
        return AppUpdateCheckResult._(
          shouldPrompt: false,
          forceUpdate: false,
          currentVersion: current,
        );
      }

      final d = snap.data()!;
      final latest = (d['latest_version'] as String?)?.trim() ?? '';
      if (latest.isEmpty) {
        return AppUpdateCheckResult._(
          shouldPrompt: false,
          forceUpdate: false,
          currentVersion: current,
        );
      }

      final minRaw = (d['min_supported_version'] as String?)?.trim();
      final message = (d['update_message'] as String?)?.trim();
      final storeUrl = (d['store_url'] as String?)?.trim();

      var url =
          (storeUrl != null &&
              storeUrl.isNotEmpty &&
              _isTrustedStoreUrl(storeUrl))
          ? storeUrl
          : _defaultStoreUrl();
      if (url.isEmpty) {
        return AppUpdateCheckResult._(
          shouldPrompt: false,
          forceUpdate: false,
          currentVersion: current,
          latestVersion: latest,
        );
      }

      final belowLatest = compareVersionStrings(current, latest) < 0;
      if (!belowLatest) {
        return AppUpdateCheckResult._(
          shouldPrompt: false,
          forceUpdate: false,
          currentVersion: current,
          latestVersion: latest,
          storeUrl: url,
        );
      }

      var force = false;
      if (minRaw != null && minRaw.isNotEmpty) {
        force = compareVersionStrings(current, minRaw) < 0;
      }

      return AppUpdateCheckResult._(
        shouldPrompt: true,
        forceUpdate: force,
        message: message,
        latestVersion: latest,
        currentVersion: current,
        storeUrl: url,
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('AppUpdateChecker: skipped ($e)');
      if (kDebugMode) debugPrint('$st');
      rethrow;
    }
  }
}
