import 'package:flutter/material.dart';

/// Uygulama renk paleti
/// Tüm renk sabitleri burada tanımlanır
abstract class AppColors {
  // ---------------------------------------------------------------------------
  // BRAND COLORS - PRIMARY (Yeşil)
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF2E9E4F);
  static const Color primaryLight = Color(0xFF7CD37E);
  static const Color primaryDark = Color(0xFF0F6B35);

  // ---------------------------------------------------------------------------
  // BRAND COLORS - SECONDARY (Mavi)
  // ---------------------------------------------------------------------------
  static const Color secondary = Color(0xFF1976D2);
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF0D47A1);

  // ---------------------------------------------------------------------------
  // ACCENT
  // ---------------------------------------------------------------------------
  static const Color accent = Color(0xFFE65100); // Turuncu

  // ---------------------------------------------------------------------------
  // SEMANTIC COLORS
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ---------------------------------------------------------------------------
  // NEUTRAL COLORS
  // ---------------------------------------------------------------------------
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ---------------------------------------------------------------------------
  // TEXT COLORS
  // ---------------------------------------------------------------------------
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textHintDark = Color(0xFF9CA3AF);
  static const Color textDisabledDark = Color(0xFF6B7280);

  // ---------------------------------------------------------------------------
  // SURFACE COLORS
  // ---------------------------------------------------------------------------
  static const Color surface = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF121212);

  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0A0A0A);

  static const Color card = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);

  // ---------------------------------------------------------------------------
  // DIVIDER & BORDER
  // ---------------------------------------------------------------------------
  static const Color divider = Color(0xFFDDDDDD);
  static const Color dividerDark = Color(0xFF373737);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // ---------------------------------------------------------------------------
  // OVERLAY & SHADOW
  // ---------------------------------------------------------------------------
  static const Color overlay = Color(0x52000000);
  static const Color shadow = Color(0x1A000000);
}

/// Light tema renk şeması
class LightColorScheme {
  static const ColorScheme scheme = ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryLight,
    tertiary: AppColors.accent,
    surface: AppColors.surface,
    error: AppColors.error,
    errorContainer: AppColors.errorLight,
    onPrimary: AppColors.white,
    onSecondary: AppColors.white,
    onSurface: AppColors.textPrimary,
    onError: AppColors.white,
    outline: AppColors.border,
  );
}

/// Dark tema renk şeması
class DarkColorScheme {
  static const ColorScheme scheme = ColorScheme.dark(
    primary: AppColors.primaryLight,
    primaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondaryLight,
    secondaryContainer: AppColors.secondaryDark,
    tertiary: AppColors.accent,
    surface: AppColors.surfaceDark,
    error: AppColors.error,
    errorContainer: AppColors.errorLight,
    onPrimary: AppColors.black,
    onSecondary: AppColors.black,
    onSurface: AppColors.textPrimaryDark,
    onError: AppColors.black,
    outline: AppColors.borderDark,
  );
}
