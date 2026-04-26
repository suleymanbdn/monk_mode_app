import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Palette ───────────────────────────────────────────────────────────────────
// Every raw color lives here. Never reference hex literals outside this file.

class AppColors {
  AppColors._();

  // Backgrounds — pure near-black hierarchy
  static const background = Color(0xFF080808);
  static const surfaceDim = Color(0xFF0D0D0D);
  static const surface = Color(0xFF111111);
  static const surfaceContainer = Color(0xFF181818);
  static const surfaceContainerHigh = Color(0xFF1E1E1E);
  static const surfaceContainerHighest = Color(0xFF252525);

  // Accent — vibrant amber gold
  static const primary = Color(0xFFFFB800);
  static const primaryDim = Color(0xFFB88A00);
  static const onPrimary = Color(0xFF1A0E00);
  static const primaryContainer = Color(0xFF2E2208);
  static const onPrimaryContainer = Color(0xFFFFE082);

  // Text
  static const onSurface = Color(0xFFF2F2F2);
  static const onSurfaceVariant = Color(0xFF9A9A9A);
  static const onSurfaceSubtle = Color(0xFF5A5A5A);

  // Tertiary — electric teal
  static const tertiary = Color(0xFF4ECDC4);

  // Semantic
  static const success = Color(0xFF00E676);
  static const onSuccess = Color(0xFF001A0E);
  static const error = Color(0xFFFF6B6B);

  // Borders & dividers
  static const outline = Color(0xFF2E2E2E);
  static const outlineVariant = Color(0xFF1E1E1E);
}

// ── Theme ─────────────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    const cs = ColorScheme(
      brightness: Brightness.dark,
      // Primary
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      // Secondary — warm amber
      secondary: Color(0xFFE09F3E),
      onSecondary: Color(0xFF1A0E00),
      secondaryContainer: Color(0xFF332200),
      onSecondaryContainer: Color(0xFFFFD180),
      tertiary: AppColors.tertiary,
      onTertiary: Color(0xFF001A1A),
      tertiaryContainer: Color(0xFF0E2626),
      onTertiaryContainer: Color(0xFFB2F5EA),
      // Error
      error: AppColors.error,
      onError: Color(0xFF1A0000),
      errorContainer: Color(0xFF2A0010),
      onErrorContainer: Color(0xFFFFCDD2),
      // Surfaces
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.surfaceDim,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      // Outlines
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      // Misc
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.onSurface,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.primaryDim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.background,

      // ── Typography ─────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        // Hero timer display
        displayLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 72,
          fontWeight: FontWeight.w100,
          letterSpacing: -2,
          height: 1,
        ),
        displayMedium: TextStyle(
          color: AppColors.onSurface,
          fontSize: 52,
          fontWeight: FontWeight.w200,
          letterSpacing: -1,
          height: 1,
        ),
        displaySmall: TextStyle(
          color: AppColors.onSurface,
          fontSize: 40,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        // Section headers
        headlineLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        headlineMedium: TextStyle(
          color: AppColors.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        // Titles
        titleLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        titleMedium: TextStyle(
          color: AppColors.onSurface,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        titleSmall: TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        // Body
        bodyLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: AppColors.onSurfaceSubtle,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        // Labels (caps, badges, tags)
        labelLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
        labelMedium: TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.4,
        ),
        labelSmall: TextStyle(
          color: AppColors.onSurfaceSubtle,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.6,
        ),
      ),

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.5,
        ),
        iconTheme: IconThemeData(color: AppColors.onSurface, size: 22),
      ),

      // ── Buttons ────────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.surfaceContainerHigh,
          disabledForegroundColor: AppColors.onSurfaceSubtle,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.onSurfaceSubtle,
          minimumSize: const Size.fromHeight(54),
          side: const BorderSide(color: AppColors.outline, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ── Cards ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // ── Icon ───────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.onSurfaceVariant,
        size: 22,
      ),

      // ── Page transitions ───────────────────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // ── Splash / Ripple ────────────────────────────────────────────────────
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
