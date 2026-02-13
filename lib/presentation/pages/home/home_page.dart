import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/sections/home_header_section.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/sections/home_quick_actions_section.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/sections/home_next_match_section.dart';
import 'package:toplansin_cleanarch/presentation/pages/home/sections/home_venue_list_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Stack(
        children: [
          // Arka plan resmi (üst kısım için)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200.h, // Header yüksekliği kadar
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/header_background.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // ÜST KISIM - Sadece Header (primary rengi)
                AppDimensions.spacing24.verticalSpace,
                HomeHeaderSection(),
                AppDimensions.spacing24.verticalSpace,

                // ALT KISIM - Üst köşeleri yuvarlatılmış (Quick Actions + İçerik)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Column(
                        children: [
                          // Quick Actions
                          HomeQuickActionsSection(
                            onReservationTap: () {},
                            onAccessCodesTap: () {},
                            onFindPlayerTap: () {},
                          ),
                          AppDimensions.spacing24.verticalSpace,
                          // Yaklaşan Maç Kartı
                          HomeNextMatchSection(),
                          // Diğer içerikler buraya eklenebilir
                          AppDimensions.spacing24.verticalSpace,
                          HomeVenueListSection(),
                          AppDimensions.spacing8.verticalSpace,
                          SizedBox(height: 100.h),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

