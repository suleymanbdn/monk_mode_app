## Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

## share_plus
-keep class dev.fluttercommunity.plus.share.** { *; }

## Google Sign-In / Play services (avoid release-only sign-in failures)
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

## Play Core (deferred components, split install) — not used but referenced by Flutter engine
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
