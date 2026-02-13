// lib/presentation/pages/home/widgets/gradient_tab_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';

class GradientTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GradientTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: 1.0
          ),
          borderRadius: BorderRadius.circular(24.r),
          gradient: LinearGradient(
            colors: isSelected
                ? [AppColors.primary, AppColors.primaryDark]
                : [AppColors.white, AppColors.white],
            stops: isSelected ? [0.0, 0.75] : [0.0, 0.5],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: isSelected ? AppColors.onPrimary : AppColors.grey600,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}