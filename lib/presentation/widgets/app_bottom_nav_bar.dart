import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, this.selectedIndex = 0, this.onTap});

  final int selectedIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.0.w,
        0.0.h,
        16.0.w,
        context.bottomPadding + 12.0.h  ,
      ),
      child: Container(
        height: 62.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A3A3A),
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(index: 0, iconPath: 'assets/icons/home_icon.svg'),
            _buildNavItem(index: 1, iconPath: 'assets/icons/list_icon.svg'),
            _buildNavItem(
              index: 2,
              iconPath: 'assets/icons/location_icon.svg',
              isMainIcon: true,
            ),
            _buildNavItem(index: 3, iconPath: 'assets/icons/search_icon.svg'),
            _buildNavItem(index: 4, iconPath: 'assets/icons/user_icon.svg'),
          ],
        ),
      ),
    );
  }

  // Animasyonlu Nav Item Builder
  Widget _buildNavItem({
    required int index,
    required String iconPath,
    bool isMainIcon = false,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: onTap != null ? () => onTap!(index) : null,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sadece ikon + daire (daire sadece ikonun arkasında)
          Stack(
            alignment: Alignment.center,
            children: [
              if (isMainIcon)
                Container(
                  width: 42.r, 
                  height: 42.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF447676),
                  ),
                ),
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: SvgPicture.asset(
                  iconPath,
                  theme: SvgTheme(
                    currentColor: isMainIcon
                        ? AppColors.white
                        : isSelected
                        ? AppColors.white
                        : AppColors.grey400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              width: isSelected ? 3.w : 0,
              height: isSelected ? 3.h : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
