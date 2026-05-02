/// Google Sign-In + Firebase Auth on Android needs:
/// 1. **SHA-1** for every certificate that **signs** the app users install:
///    - Local debug / release keystore (from `gradlew signingReport`), **and**
///    - If the app is installed from **Google Play**, also the **App signing key**
///      (Play Console → Release → Setup → App integrity → App signing key certificate),
///      which is **not** the same as your upload key. Add that SHA-1 in Firebase too.
/// 2. Re-download **`android/app/google-services.json`** after adding fingerprints.
/// 3. **Web OAuth client ID** (`client_type: 3` in JSON) — see [kGoogleWebClientId].
///
/// Optional override (non-empty wins; an **empty** define no longer clears the default):
/// `flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=....apps.googleusercontent.com`
const String _kWebClientIdDefault =
    '696315304984-r8u0f8ie8un8uem3nt1ltt6iu16gats1.apps.googleusercontent.com';

const String _kWebClientIdFromEnv = String.fromEnvironment(
  'GOOGLE_WEB_CLIENT_ID',
);

/// Web client ID for [GoogleSignIn.serverClientId] (Firebase id token).
String get kGoogleWebClientId => _kWebClientIdFromEnv.isNotEmpty
    ? _kWebClientIdFromEnv
    : _kWebClientIdDefault;
