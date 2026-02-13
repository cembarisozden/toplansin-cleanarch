import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/constants/onboarding_content.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingItem({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Arka plan görsel (tam ekran)
        Image.asset(
          content.imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

 
        // İçerik (başlık + açıklama)
        Positioned(
          left: AppDimensions.spacing24.w,
          right: AppDimensions.spacing24.w,
          bottom: 180.h,  // Buton için yer bırak
          child: Column(
            children: [
              Text(
                content.title,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              AppDimensions.spacing16.verticalSpace,
              Text(
                content.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}