import 'package:flutter/material.dart';

/// Uygulama boyut sabitleri
/// Spacing, padding, radius, icon size vs.
abstract class AppDimensions {
  // ---------------------------------------------------------------------------
  // SPACING (Margin & Padding)
  // ---------------------------------------------------------------------------
  static const double spacing0 = 0;
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;

  // ---------------------------------------------------------------------------
  // BORDER RADIUS
  // ---------------------------------------------------------------------------
  static const double radiusNone = 0;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  // BorderRadius objects
  static BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // ---------------------------------------------------------------------------
  // ICON SIZES
  // ---------------------------------------------------------------------------
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 40;
  static const double iconXxl = 48;

  // ---------------------------------------------------------------------------
  // BUTTON SIZES
  // ---------------------------------------------------------------------------
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 52;

  // ---------------------------------------------------------------------------
  // INPUT FIELD
  // ---------------------------------------------------------------------------
  static const double inputHeight = 48;
  static const double inputBorderWidth = 1;
  static const double inputFocusBorderWidth = 2;

  // ---------------------------------------------------------------------------
  // CARD
  // ---------------------------------------------------------------------------
  static const double cardElevation = 2;
  static const double cardRadius = 12;

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------
  static const double appBarHeight = 56;
  static const double appBarElevation = 0;

  // ---------------------------------------------------------------------------
  // BOTTOM NAV
  // ---------------------------------------------------------------------------
  static const double bottomNavHeight = 64;

  // ---------------------------------------------------------------------------
  // DIVIDER
  // ---------------------------------------------------------------------------
  static const double dividerThickness = 1;

  // ---------------------------------------------------------------------------
  // AVATAR
  // ---------------------------------------------------------------------------
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 64;
  static const double avatarXl = 96;

  // ---------------------------------------------------------------------------
  // PAGE PADDING
  // ---------------------------------------------------------------------------
  static const EdgeInsets pagePadding = EdgeInsets.all(spacing16);
  static const EdgeInsets pagePaddingHorizontal =
      EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets pagePaddingVertical =
      EdgeInsets.symmetric(vertical: spacing16);
}

/// Spacing widget'ları için kısa yollar
class Gap {
  const Gap._();

  // Horizontal gaps
  static const SizedBox h4 = SizedBox(width: AppDimensions.spacing4);
  static const SizedBox h8 = SizedBox(width: AppDimensions.spacing8);
  static const SizedBox h12 = SizedBox(width: AppDimensions.spacing12);
  static const SizedBox h16 = SizedBox(width: AppDimensions.spacing16);
  static const SizedBox h24 = SizedBox(width: AppDimensions.spacing24);
  static const SizedBox h32 = SizedBox(width: AppDimensions.spacing32);

  // Vertical gaps
  static const SizedBox v4 = SizedBox(height: AppDimensions.spacing4);
  static const SizedBox v8 = SizedBox(height: AppDimensions.spacing8);
  static const SizedBox v12 = SizedBox(height: AppDimensions.spacing12);
  static const SizedBox v16 = SizedBox(height: AppDimensions.spacing16);
  static const SizedBox v24 = SizedBox(height: AppDimensions.spacing24);
  static const SizedBox v32 = SizedBox(height: AppDimensions.spacing32);
  static const SizedBox v48 = SizedBox(height: AppDimensions.spacing48);
}

