import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';

class QuickActionsButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const QuickActionsButton({
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              12.r,
            ),
            onTap: onTap,
            child: Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.primaryLightHighest,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  iconPath,
                  width: 12.r,
                  height: 12.r,
                  colorFilter: ColorFilter.mode(iconColor ?? AppColors.primaryDark, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
        AppDimensions.spacing6.verticalSpace,
        SizedBox(
          child: Text(
            label,
            style: context.textTheme.bodyMedium
                ?.copyWith(
                  color:
                      context.colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
