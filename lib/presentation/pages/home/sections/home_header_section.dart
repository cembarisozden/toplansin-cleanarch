import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_bloc.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_state.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 12.w,
            children: [
              SizedBox(
                width: 48.r,
                height: 48.r,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    BlocSelector<AuthBloc, AuthState, String?>(
                      selector: (state) {
                        if (state is AuthAuthenticated) {
                          return state.user.photoUrl;
                        }
                        return null;
                      },
                      builder: (context, photoUrl) {
                        if (photoUrl == null || photoUrl.isEmpty) {
                        return CircleAvatar(
                          radius: 24.r,
                          child: Icon(
                            Icons.person,
                            color: context.colorScheme.onPrimary,
                            size: 24.r,
                          ),
                        );
                        }
                        else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(photoUrl, fit: BoxFit.cover, width: 48.r, height: 48.r, errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: context.colorScheme.onPrimary,
                                size: 24.r,
                              );
                            },),
                          ),
                        );
                        }
                      },
                    ),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colorScheme.primary,
                            width: 2.w,
                          ),
                        ),
                        width: 14.r,
                        height: 14.r,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Merhaba,',
                    style: context.textTheme.bodyLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                  ),
                  BlocSelector<AuthBloc, AuthState, String?>
                  (selector: (state){
                    if (state is AuthAuthenticated){
                      return state.user.displayName;
                    }
                    return 'Kaptan';
                  }, builder: (context, displayName) {
                    return SizedBox(
                      width: context.screenWidth * 0.6,
                      child: Text(
                        '$displayName👋',
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_outlined,
              color: context.colorScheme.onPrimary,
              size: 28.r,
            ),
          ),
        ],
      ),
    );
  }
}
