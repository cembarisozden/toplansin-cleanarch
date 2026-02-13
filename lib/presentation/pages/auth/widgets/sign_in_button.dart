// lib/presentation/pages/auth/widgets/sign_in_button.dart
//
// 📌 SignInButton - Social login butonları için özel widget
//
// Özellikler:
// - İkon + label kombinasyonu
// - Özelleştirilebilir renkler
// - Loading state desteği

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';

class SignInButton extends StatelessWidget {
  final String icon;
  final String label;
  
  /// null ise buton disabled olur
  final VoidCallback? onPressed;
  
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  
  /// Loading durumunda spinner gösterilir
  final bool isLoading;

  const SignInButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Disabled durumu: onPressed null veya loading aktif
    final isDisabled = onPressed == null || isLoading;
    
    // Background rengi
    final bgColor = backgroundColor ?? AppColors.white;
    
    // Disabled'da renkleri soluklaştır
    final effectiveBgColor = isDisabled ? bgColor.withOpacity(0.4) : bgColor;
    final effectiveTextColor = isDisabled
        ? (textColor ?? context.colorScheme.onSurfaceVariant).withOpacity(0.6)
        : (textColor ?? context.colorScheme.onSurfaceVariant);

    return Container(
      width: double.infinity,
      height: 55.h,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(
          color: borderColor ?? AppColors.black.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          disabledBackgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: isLoading
            // ─────────────────────────────────────────────────────
            // 🔄 LOADING DURUMU - Spinner göster
            // ─────────────────────────────────────────────────────
            ? SizedBox(
                width: 24.r,
                height: 24.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveTextColor,
                  ),
                ),
              )
            // ─────────────────────────────────────────────────────
            // 📝 NORMAL DURUM - İkon + Label
            // ─────────────────────────────────────────────────────
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    icon,
                    width: 18.w,
                    height: 18.h,
                    // Disabled durumunda ikonu soluklaştır
                    colorFilter: isDisabled
                        ? ColorFilter.mode(
                            AppColors.grey400,
                            BlendMode.srcIn,
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    label,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: effectiveTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
