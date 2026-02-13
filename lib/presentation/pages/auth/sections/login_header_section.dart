
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';

class LoginHeaderSection extends StatelessWidget {
  const LoginHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/yeni_logo2_nobg.png',
              width: 80.w,
              height: 20.h,
            ),
        
          ],
        ),
        AppDimensions.spacing24.verticalSpace,
        Text(
          'Get Started now',
          style: context.textTheme.headlineLarge?.copyWith(
            color: AppColors.white,
          ),
        ),
        AppDimensions.spacing12.verticalSpace,
        Text(
          'Create an account or log in to explore about our app',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}