import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';

class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive
                ? context.colorScheme.primary
                : context.colorScheme.outline,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}