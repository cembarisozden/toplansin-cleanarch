import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({
    super.key,
    required this.venue,
    required this.isSaved,
    required this.userId,
    required this.onSaveTap,
  });
  final VenueEntity venue;
  final bool isSaved;
  final String userId;
  final Function(String venueId, String userId, VenueEntity? venue) onSaveTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * 0.8,
      height: context.screenHeight * 0.25,
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.outline, width: 1.w),
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Üst kısım: Resim alanı (badge'ler için Stack)
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Resim
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: Image.network(
                    venue.imagesUrl.first,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/venue_card_background.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
                // Premium badge
                if (venue.isPremium)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8.r),
                          topLeft: Radius.circular(8.r),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary,
                            AppColors.secondaryDark,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icon_crown.svg',
                            colorFilter: ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                            width: 10.w,
                            height: 10.h,
                          ),
                          AppDimensions.spacing4.horizontalSpace,
                          Text(
                            'Premium',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Bookmark icon
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    width: 32.r, // veya 24.r daha küçük istersen
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isSaved
                            ? Icons.bookmark_outlined
                            : Icons.bookmark_border_outlined,
                      ),
                      onPressed: () {
                        onSaveTap(venue.id, userId, venue);
                      },
                      color: AppColors.grey500,
                      iconSize: 16.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Alt kısım: Yazı alanı
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Venue name + rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        venue.name,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '⭐ ${venue.rating} (${venue.totalReviews})',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                AppDimensions.spacing4.verticalSpace,
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.grey500,
                      size: 14.r,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        venue.location,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppDimensions.spacing6.verticalSpace,
                Divider(color: AppColors.grey400, thickness: 0.3.h),
                AppDimensions.spacing6.verticalSpace,
                // Price
                Row(
                  children: [
                    Text(
                      '₺ ${venue.price.toInt()}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' / Saatlik',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
