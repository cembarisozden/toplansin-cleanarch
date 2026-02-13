// core/widgets/custom_snackbar.dart
//
// 📌 CustomSnackBar - Özelleştirilmiş snackbar widget'ı
//
// Clean Architecture'a uygun, merkezi snackbar yönetimi
// Tüm snackbar'lar buradan yönetilir

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final colors = _getColors(type);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getIcon(type),
              color: colors['icon'],
              size: 20.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colors['text'],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colors['background'],
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        action: action,
      ),
    );
  }

  static Map<String, Color> _getColors(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return {
          'background': AppColors.success,
          'icon': AppColors.onSuccess,
          'text': AppColors.onSuccess,
        };
      case SnackBarType.error:
        return {
          'background': AppColors.error,
          'icon': AppColors.onError,
          'text': AppColors.onError,
        };
      case SnackBarType.warning:
        return {
          'background': AppColors.warning,
          'icon': AppColors.onWarning,
          'text': AppColors.onWarning,
        };
      case SnackBarType.info:
        return {
          'background': AppColors.info,
          'icon': AppColors.onInfo,
          'text': AppColors.onInfo,
        };
    }
  }

  static IconData _getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
      case SnackBarType.info:
        return Icons.info_outline;
    }
  }
}

