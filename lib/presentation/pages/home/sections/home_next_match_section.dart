import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/widgets/next_match_remain_date_box.dart';

class HomeNextMatchSection extends StatelessWidget {
  const HomeNextMatchSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: context.screenHeight * 0.2,
            width: context.screenWidth*0.92,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow,
                  blurRadius: 10.r,
                  offset: Offset(0, 10.r),
                ),
              ],
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusLg,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusLg,
              ),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Image.asset(
                  'assets/images/next_match_background_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Yaklaşan Maçın',
                    style: context.textTheme.titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                  ),
                  AppDimensions.spacing12.verticalSpace,
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start,
                    spacing: 12.w,
                    children: [
                      NextMatchRemainDateBox(
                        remainDateType: RemainDateType.days,
                        value: '02',
                      ),
                      Text(
                        ':',
                        style: context
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                      ),
                      NextMatchRemainDateBox(
                        remainDateType: RemainDateType.hours,
                        value: '14',
                      ),
                      Text(
                        ':',
                        style: context
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                      ),
                      NextMatchRemainDateBox(
                        remainDateType: RemainDateType.minutes,
                        value: '30',
                      ),
                    ],
                  ),
                  AppDimensions.spacing12.verticalSpace,
                  Row(
                    children: [
                      Text(
                        '26 Ekim, 19:00 - Bornova Halı Saha',
                        style: context
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w300,
                              color: AppColors.white,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}