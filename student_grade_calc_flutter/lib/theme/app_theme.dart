import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppColors — all named color constants used throughout the app.
/// Reference these by name (e.g. AppColors.textSecondary), never by hex value.
abstract class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F7F7);
  static const Color surfaceDim = Color(0xFFEEEEEE);

  // Borders
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderDash = Color(0xFFCCCCCC);

  // Text
  static const Color textPrimary = Color(0xFF0D0D0D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFFAAAAAA);

  // Interactive
  static const Color accent = Color(0xFF0D0D0D);
  static const Color accentFg = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF2D6A4F);
  static const Color successBg = Color(0xFFD8F3DC);
  static const Color danger = Color(0xFF9B2226);
  static const Color dangerBg = Color(0xFFFFE8E8);

  // Grade badge
  static const Color badgeBg = Color(0xFFF0F0F0);
  static const Color badgeFg = Color(0xFF0D0D0D);
}

/// AppSpacing — spacing constants based on an 8px grid.
abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// AppRadius — consistent border radius values.
abstract class AppRadius {
  static const double card = 12.0;
  static const double button = 24.0;
  static const double badge = 6.0;
}

/// AppTextStyles — named text styles. Use these everywhere, not raw TextStyle().
abstract class AppTextStyles {
  static TextStyle display({Color color = AppColors.textPrimary}) =>
      GoogleFonts.urbanist(
          fontSize: 24, fontWeight: FontWeight.w700, color: color);

  static TextStyle heading({Color color = AppColors.textPrimary}) =>
      GoogleFonts.urbanist(
          fontSize: 18, fontWeight: FontWeight.w600, color: color);

  static TextStyle body({Color color = AppColors.textPrimary}) =>
      GoogleFonts.urbanist(
          fontSize: 14, fontWeight: FontWeight.w400, color: color);

  static TextStyle caption({Color color = AppColors.textSecondary}) =>
      GoogleFonts.urbanist(
          fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle label({Color color = AppColors.textPrimary}) =>
      GoogleFonts.urbanist(
          fontSize: 13, fontWeight: FontWeight.w500, color: color);
}

/// AppTheme — the MaterialApp theme. Pass AppTheme.light() to MaterialApp.theme.
class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        surface: AppColors.surface,
        primary: AppColors.accent,
        onPrimary: AppColors.accentFg,
        onSurface: AppColors.textPrimary,
        outline: AppColors.border,
      ),
      textTheme: GoogleFonts.urbanistTextTheme(),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.accentFg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: AppTextStyles.label(color: AppColors.accentFg),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.heading(),
        centerTitle: false,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textHint,
        selectedLabelStyle: AppTextStyles.caption(color: AppColors.textPrimary),
        unselectedLabelStyle: AppTextStyles.caption(),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
