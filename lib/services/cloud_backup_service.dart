import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart';

import '../config/backup_sign_in_config.dart';
import '../models/app_stats.dart';
import '../utils/firestore_value_utils.dart';

/// Google Sign-In setup error (see [kind] for next steps in UI).
class BackupSignInSetupException implements Exception {
  const BackupSignInSetupException(this.kind);

  final BackupSignInKind kind;
}

/// [androidDeveloperError] = Play/upload SHA missing in Firebase (ApiException 10, etc.).
/// [missingIdToken] = Web [serverClientId] not applied or stripped in release.
enum BackupSignInKind { androidDeveloperError, missingIdToken }

/// Result returned after a successful sign-in attempt.
///
/// [cloudStats] is non-null when existing backup data was found in Firestore.
class BackupSignInResult {
  const BackupSignInResult({
    required this.user,
    this.cloudStats,
    this.cloudTogetherTotal = 0,
  });

  final User user;

  /// Cloud stats found for this Google account, if any.
  final AppStats? cloudStats;
  final int cloudTogetherTotal;

  bool get hasCloudData => cloudStats != null;
}

/// Manages Google Sign-In and Firestore stat backup/restore.
///
/// All data lives at `users/{uid}` (a flat document, no sub-collections).
/// Only the authenticated user can read/write their own document.
///
/// Stat keys stored:
///   currentStreak, longestStreak, totalSessions, totalMinutes,
///   dopamineScore, lastSessionDate, togetherTotal, syncedAt.
abstract final class CloudBackupService {
  static const _kCollection = 'users';

  static final _googleSignIn = GoogleSignIn(
    scopes: const <String>['email', 'profile'],
    // Required on Android for Firebase to receive a non-null ID token in most cases.
    serverClientId: kGoogleWebClientId.isEmpty ? null : kGoogleWebClientId,
  );
  static FirebaseFirestore get _db => FirebaseFirestore.instance;
  static FirebaseAuth get _auth => FirebaseAuth.instance;

  // ── Getters ───────────────────────────────────────────────────────────────

  /// Whether Firebase is available in this build.
  static bool get _firebaseAvailable => Firebase.apps.isNotEmpty;

  static User? get currentUser => _firebaseAvailable ? _auth.currentUser : null;

  /// True when the current Firebase user has a Google provider linked.
  static bool get isSignedInWithGoogle {
    final u = currentUser;
    if (u == null) return false;
    return u.providerData.any((p) => p.providerId == 'google.com');
  }

  static String? get signedInEmail {
    final u = currentUser;
    if (u == null || !isSignedInWithGoogle) return null;
    return u.email ??
        u.providerData
            .firstWhere(
              (p) => p.providerId == 'google.com',
              orElse: () => u.providerData.first,
            )
            .email;
  }

  // ── Sign-in ───────────────────────────────────────────────────────────────

  /// Initiates Google Sign-In, links to the current anonymous account when
  /// possible, and returns a [BackupSignInResult] including any existing cloud
  /// data so the caller can offer a restore dialog.
  ///
  /// Returns `null` if the user cancelled or Firebase is unavailable.
  static Future<BackupSignInResult?> signInWithGoogle() async {
    if (!_firebaseAvailable) return null;

    GoogleSignInAccount? account;
    try {
      account = await _googleSignIn.signIn();
    } on PlatformException catch (e) {
      if (_isAndroidDeveloperError(e)) {
        if (kDebugMode) debugPrint('Google sign-in: $e');
        throw const BackupSignInSetupException(
          BackupSignInKind.androidDeveloperError,
        );
      }
      rethrow;
    }
    if (account == null) return null; // user cancelled

    final googleAuth = await account.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null || idToken.isEmpty) {
      if (kDebugMode) {
        debugPrint(
          'Google sign-in: idToken is null. Set kGoogleWebClientId (Web client) '
          'in backup_sign_in_config.dart or --dart-define=GOOGLE_WEB_CLIENT_ID=...',
        );
      }
      throw const BackupSignInSetupException(BackupSignInKind.missingIdToken);
    }
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: idToken,
    );

    User? user;
    final currentAnon = _auth.currentUser;
    if (currentAnon != null && currentAnon.isAnonymous) {
      try {
        final result = await currentAnon.linkWithCredential(credential);
        user = result.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {
          // Google account already has its own Firebase account — sign in fresh.
          final result = await _auth.signInWithCredential(credential);
          user = result.user;
        } else {
          rethrow;
        }
      }
    } else {
      final result = await _auth.signInWithCredential(credential);
      user = result.user;
    }

    if (user == null) return null;

    final cloud = await _downloadStatsForUid(user.uid);
    return BackupSignInResult(
      user: user,
      cloudStats: cloud?.$1,
      cloudTogetherTotal: cloud?.$2 ?? 0,
    );
  }

  // ── Sign-out ──────────────────────────────────────────────────────────────

  /// Signs out the Google account and re-creates an anonymous Firebase user
  /// so Focus Together rooms continue to work.
  static Future<void> signOut() async {
    if (!_firebaseAvailable) return;
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _auth.signInAnonymously();
    } catch (_) {}
  }

  // ── Upload ────────────────────────────────────────────────────────────────

  /// Writes [stats] and [togetherTotal] to `users/{uid}`.
  /// No-ops silently when not signed in with Google.
  static Future<void> uploadStats(
    AppStats stats, {
    required int togetherTotal,
  }) async {
    if (!_firebaseAvailable || !isSignedInWithGoogle) return;
    final uid = currentUser!.uid;
    final safe = FirestoreValueUtils.sanitizeAppStatsMap(stats.toJson());
    final safeTogether = FirestoreValueUtils.sanitizeTogetherTotal(
      togetherTotal,
    );
    await _db.collection(_kCollection).doc(uid).set({
      ...safe.toJson(),
      'togetherTotal': safeTogether,
      'syncedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Download ──────────────────────────────────────────────────────────────

  /// Returns `(AppStats, togetherTotal)` from Firestore, or `null` if no
  /// document exists or the user is not signed in with Google.
  static Future<(AppStats, int)?> downloadStats() async {
    if (!_firebaseAvailable || !isSignedInWithGoogle) return null;
    return _downloadStatsForUid(currentUser!.uid);
  }

  static Future<(AppStats, int)?> _downloadStatsForUid(String uid) async {
    try {
      final snap = await _db.collection(_kCollection).doc(uid).get();
      if (!snap.exists) return null;
      final d = snap.data()!;
      return (
        FirestoreValueUtils.sanitizeAppStatsMap(Map<String, dynamic>.from(d)),
        FirestoreValueUtils.sanitizeTogetherTotal(d['togetherTotal']),
      );
    } catch (_) {
      return null;
    }
  }
}

/// Play / debug keystore SHA missing in Firebase → Google [ApiException] 10, etc.
bool _isAndroidDeveloperError(PlatformException e) {
  final blob = '${e.code} ${e.message ?? ''} ${e.details ?? ''}';
  if (blob.contains('DEVELOPER_ERROR')) return true;
  if (blob.contains('12500')) return true;
  if (blob.contains('ApiException') && blob.contains('10')) return true;
  if (e.code == 'sign_in_failed' &&
      (blob.contains('10') || blob.contains('12500'))) {
    return true;
  }
  return false;
}
