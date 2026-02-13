import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';

enum RemainDateType {
  days,
  hours,
  minutes,
}
class NextMatchRemainDateBox extends StatelessWidget {

  const NextMatchRemainDateBox({super.key,  required this.remainDateType, required this.value});
  final RemainDateType remainDateType;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          Text(
            remainDateType == RemainDateType.days ? 'GÜN' : remainDateType == RemainDateType.hours ? 'SAAT' : remainDateType == RemainDateType.minutes ? 'DAKİKA' : '',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w300,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
