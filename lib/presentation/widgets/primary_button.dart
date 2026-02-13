// lib/presentation/widgets/primary_button.dart
//
// 📌 PrimaryButton - Uygulamanın ana buton widget'ı
//
// Özellikler:
// - Loading durumunda spinner gösterir
// - Disabled state desteği
// - Tema renkleriyle uyumlu

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  
  /// null ise buton disabled olur
  final VoidCallback? onPressed;
  
  /// Loading durumunda spinner gösterilir
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Disabled durumu: onPressed null veya loading aktif
    final isDisabled = onPressed == null || isLoading;

    return Container(
      width: double.infinity,
      height: 55.h,
      decoration: BoxDecoration(
        // Disabled durumunda rengi soluklaştır
        color: isDisabled
            ? context.colorScheme.primary.withOpacity(0.6)
            : context.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius),
          ),
          // Disabled durumunda background'u transparent yap
          // Container zaten renklendiriyor
          disabledBackgroundColor: Colors.transparent,
        ),
        // Loading'de veya null'sa disable et
        onPressed: isDisabled ? null : onPressed,
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
                    context.colorScheme.onPrimary,
                  ),
                ),
              )
            // ─────────────────────────────────────────────────────
            // 📝 NORMAL DURUM - Label göster
            // ─────────────────────────────────────────────────────
            : Text(
                label,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
