import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'features/focus_room/data/firestore_focus_room_repository.dart';
import 'features/focus_room/data/in_memory_focus_room_repository.dart';
import 'features/focus_room/focus_room_runtime.dart';
import 'firebase_options.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  registerFocusRoomRepository(InMemoryFocusRoomRepository());
  focusRoomCloudSyncEnabled = false;

  // Firebase Core: needed for in-app update checks (Firestore `app_config`) even if
  // Anonymous sign-in fails. Focus Together still requires successful auth below.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode) debugPrint('Firebase initialized');
  } catch (e, st) {
    if (kDebugMode) debugPrint('Firebase init failed ($e)');
    if (kDebugMode) debugPrint('$st');
  }

  // Requires Anonymous sign-in enabled in Firebase Console (Auth → sign-in method).
  // Do not call signInAnonymously() when a user (e.g. Google backup) is already
  // restored from persistence — that would sign them out and replace with anon.
  if (Firebase.apps.isNotEmpty) {
    try {
      await _ensureAnonOrRestoredUser();
      registerFocusRoomRepository(FirestoreFocusRoomRepository());
      focusRoomCloudSyncEnabled = true;
      if (kDebugMode) debugPrint('Focus Together: Firestore on');
    } catch (e, st) {
      if (kDebugMode) debugPrint('Focus Together: signed-out / offline ($e)');
      if (kDebugMode) debugPrint('$st');
    }
  }

  // ── Display ──────────────────────────────────────────────────────────────
  // Edge-to-edge: content draws behind both status and navigation bars.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // ── Orientation ──────────────────────────────────────────────────────────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── System UI chrome ─────────────────────────────────────────────────────
  // Transparent bars so our dark scaffold bleeds through.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // ── Storage ──────────────────────────────────────────────────────────────
  final storage = StorageService();
  await storage.init();

  // ── Launch ───────────────────────────────────────────────────────────────
  runApp(App(storage: storage));
}

/// Wait for Firebase Auth to restore a persisted user (Google backup, previous
/// anonymous, etc.). Only when still unauthenticated, sign in anonymously for
/// Focus Together.
Future<void> _ensureAnonOrRestoredUser() async {
  if (FirebaseAuth.instance.currentUser != null) return;

  try {
    await FirebaseAuth.instance
        .authStateChanges()
        .firstWhere((User? u) => u != null)
        .timeout(const Duration(seconds: 2));
  } on TimeoutException {
    // No restored session (or not yet in time window).
  }

  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }
}
