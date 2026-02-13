// lib/presentation/pages/auth/sections/login_bottom_section.dart
//
// 📌 LoginBottomSection - Action butonları
//
// İçerik:
// - Ana buton (Log In / Sign Up)
// - "Or" divider
// - Google sign in butonu
// - Apple sign in butonu

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/presentation/pages/auth/widgets/sign_in_button.dart';
import 'package:toplansin_cleanarch/presentation/widgets/primary_button.dart';

class LoginBottomSection extends StatelessWidget {
  final VoidCallback onLogInTap;
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;
  final bool isSignUp;
  
  // ─────────────────────────────────────────────────────────────
  // 🆕 YENİ PARAMETRE - Loading durumu
  // ─────────────────────────────────────────────────────────────
  
  /// Loading durumunda butonlar disable olur
  final bool isLoadingLogin;
  final bool isLoadingGoogle;
  final bool isLoadingApple;

  const LoginBottomSection({
    super.key,
    required this.onLogInTap,
    required this.onGoogleTap,
    required this.onAppleTap,
    required this.isSignUp,
    this.isLoadingLogin = false,
    this.isLoadingGoogle = false,
    this.isLoadingApple = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─────────────────────────────────────────────────────────
        // 🔵 ANA BUTON - Login veya Sign Up
        // ─────────────────────────────────────────────────────────
        PrimaryButton(
          label: isSignUp ? 'Sign Up with Email' : 'Log In with Email',
          // Loading'de butonu disable et
          onPressed: isLoadingLogin ? null : onLogInTap,
          isLoading: isLoadingLogin, // 👈 Buton içinde spinner göster
        ),
        AppDimensions.spacing16.verticalSpace,

        // ─────────────────────────────────────────────────────────
        // ➖ DIVIDER - "Or"
        // ─────────────────────────────────────────────────────────
        Row(
          children: [
            Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Or',
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(child: Divider(thickness: 1)),
          ],
        ),
        AppDimensions.spacing16.verticalSpace,

        // ─────────────────────────────────────────────────────────
        // 🔴 GOOGLE BUTONU
        // ─────────────────────────────────────────────────────────
        SignInButton(
          icon: 'assets/icons/logo_google.svg',
          label: isSignUp ? 'Sign Up with Google' : 'Continue with Google',
          onPressed: isLoadingGoogle ? null : onGoogleTap,
          textColor: AppColors.black,
          isLoading: isLoadingGoogle,
        ),
        AppDimensions.spacing16.verticalSpace,

        // ─────────────────────────────────────────────────────────
        // ⚫ APPLE BUTONU
        // ─────────────────────────────────────────────────────────
        SignInButton(
          icon: 'assets/icons/logo_apple.svg',
          label: isSignUp ? 'Sign Up with Apple' : 'Continue with Apple',
          onPressed: isLoadingApple ? null : onAppleTap,
          backgroundColor: AppColors.black,
          borderColor: AppColors.black,
          textColor: AppColors.white,
          isLoading: isLoadingApple,
        ),
      ],
    );
  }
}
