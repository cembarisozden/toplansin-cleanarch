import 'package:flutter/material.dart';

/// Uygulama renk paleti - Tüm renk sabitleri
abstract class AppColors {
  // ─────────────────────────────────────────────────────────────────────────
  // BRAND - PRIMARY (Emerald)
  // ─────────────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF059669);
  static const Color primaryLight = Color(0xFF4FD5A8);
  static const Color primaryLightHighest = Color(0xFFD1FAE5); // ✅ primaryLight'ın çok açık versiyonu

  
  static const Color primaryDark = Color(0xFF047857);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFF022C22); // Dark theme için

  // ─────────────────────────────────────────────────────────────────────────
  // BRAND - SECONDARY (Blue)
  // ─────────────────────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF1976D2);
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF0D47A1);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────────────────────────────────
  // ACCENT
  // ─────────────────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFFE65100);
  static const Color onAccent = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC - STATUS COLORS
  // ─────────────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successContainer = Color(0xFFDCFCE7);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color onSuccessContainer = Color(0xFF166534);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarning = Color(0xFF1F2937);
  static const Color onWarningContainer = Color(0xFF92400E);

  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFFB91C1C);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoContainer = Color(0xFFDBEAFE);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color onInfoContainer = Color(0xFF1E40AF);

  // ─────────────────────────────────────────────────────────────────────────
  // NEUTRAL
  // ─────────────────────────────────────────────────────────────────────────
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

  // ─────────────────────────────────────────────────────────────────────────
  // OVERLAY & SHADOW
  // ─────────────────────────────────────────────────────────────────────────
  static const Color overlay = Color(0x52000000);
  static const Color shadow = Color(0x40000000);
}

/// Light tema renkleri
abstract class LightColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color card = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFDDDDDD);
}

/// Dark tema renkleri
abstract class DarkColors {
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color( 0xFF1F1F1F);
  static const Color surfaceVariant = Color(0xFF1E1E1E);
  static const Color card = Color(0xFF1E1E1E);

  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFF6B7280);

  static const Color border = Color(0xFF374151);
  static const Color divider = Color(0xFF373737);
}

/// Light tema ColorScheme
class LightColorScheme {
  static const ColorScheme scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.secondaryDark,
    tertiary: AppColors.accent,
    onTertiary: AppColors.onAccent,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: LightColors.surface,
    onSurface: LightColors.textPrimary,
    surfaceContainerHighest: LightColors.card,
    onSurfaceVariant: LightColors.textSecondary,
    outline: LightColors.border,
    outlineVariant: LightColors.divider,
    shadow: AppColors.shadow,
    scrim: AppColors.overlay,
    inverseSurface: AppColors.grey800,
    onInverseSurface: AppColors.white,
    inversePrimary: AppColors.primaryLight,
  );
}

/// Dark tema ColorScheme
class DarkColorScheme {
  static const ColorScheme scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryLight, // Dark'ta daha açık ton
    onPrimary: AppColors.onPrimaryDark, // Koyu metin (kontrast için)
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.black, // Yüksek kontrast için koyu
    secondaryContainer: AppColors.secondaryDark,
    onSecondaryContainer: AppColors.secondaryLight,
    tertiary: AppColors.accent,
    onTertiary: AppColors.onAccent,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.black,
    onErrorContainer: AppColors.onErrorContainer,
    surface: DarkColors.surface,
    onSurface: DarkColors.textPrimary,
    surfaceContainerHighest: DarkColors.card,
    onSurfaceVariant: DarkColors.textSecondary,
    outline: DarkColors.border,
    outlineVariant: DarkColors.divider,
    shadow: Color(0x1AFFFFFF), // %10 opacity beyaz,
    scrim: AppColors.overlay,
    inverseSurface: AppColors.white,
    onInverseSurface: AppColors.black,
    inversePrimary: AppColors.primary,
  );
}