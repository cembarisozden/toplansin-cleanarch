import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/widgets/quick_actions_button.dart';

class HomeQuickActionsSection extends StatelessWidget {
  final VoidCallback onReservationTap;
  final VoidCallback onAccessCodesTap;
  final VoidCallback onFindPlayerTap;
  const HomeQuickActionsSection({
    super.key,
    required this.onReservationTap,
    required this.onAccessCodesTap,
    required this.onFindPlayerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 12.w,
        children: [
          QuickActionsButton(
            iconPath: 'assets/icons/reservation_icon.svg',
            label: 'Rezervasyon\nYap',
            onTap: onReservationTap,
            backgroundColor: AppColors.primaryDark,
            iconColor: AppColors.white,
          ),
          QuickActionsButton(
            iconPath: 'assets/icons/key_icon.svg',
            label: 'Erişim\nKodları',
            onTap: onAccessCodesTap,
          ),
          QuickActionsButton(
            iconPath: 'assets/icons/people_group_icon.svg',
            label: 'Eksik Oyuncu\nBul',
            onTap: onFindPlayerTap,
    
          ),
        ],
      ),
      
    );
  }
}

