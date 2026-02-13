// lib/presentation/pages/auth/sections/login_body_section.dart
//
// 📌 LoginBodySection - Tab bar ve form alanları
//
// İçerik:
// - Login/Sign Up tab bar
// - Email input (her iki modda)
// - Password input (sadece login modunda)
// - Forgot Password linki (sadece login modunda)

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_colors.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/presentation/widgets/primary_text_field.dart';

class LoginBodySection extends StatelessWidget {
  const LoginBodySection({
    super.key,
    required TabController tabController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool isSignUp,
    this.isLoadingSignUp = false,
    this.isLoadingLogin = false,
    this.errorMessage,
  })  : _tabController = tabController,
        _emailController = emailController,
        _passwordController = passwordController,
        _isSignUp = isSignUp;

  final TabController _tabController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final bool _isSignUp;
  
  // ─────────────────────────────────────────────────────────────
  // 🆕 YENİ PARAMETRELER - Bloc state'inden gelir
  // ─────────────────────────────────────────────────────────────
  
  /// Loading durumunda input'lar disable olur ve spinner gösterilir
  final bool isLoadingSignUp;
  final bool isLoadingLogin;
  
  /// Error mesajı - Email field altında gösterilir
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    // Error varsa hasError true olur
    final hasError = errorMessage != null;

    return Column(
      children: [
        // ─────────────────────────────────────────────────────────
        // 🔲 TAB BAR - Login/Sign Up seçimi
        // ─────────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            indicatorPadding: EdgeInsets.all(4.r),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: context.colorScheme.onSurfaceVariant,
            unselectedLabelColor: context.colorScheme.onSurfaceVariant,
            labelStyle: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Log In'),
              Tab(text: 'Sign Up'),
            ],
          ),
        ),
        AppDimensions.spacing24.verticalSpace,

        // ─────────────────────────────────────────────────────────
        // 📧 EMAIL INPUT
        // ─────────────────────────────────────────────────────────
        // Her iki modda da gösterilir
        // Loading durumunda spinner gösterilir
        // Error durumunda kırmızı border + hata mesajı
        PrimaryTextField(
          hintText: 'Email',
          headerText: 'Email',
          controller: _emailController,
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
          isLoading: isLoadingSignUp,       // 👈 Loading state
          hasError: hasError,          // 👈 Error state
          errorMessage: errorMessage,  // 👈 Error mesajı
        ),

        // ─────────────────────────────────────────────────────────
        // 🔐 PASSWORD INPUT - Sadece Login modunda
        // ─────────────────────────────────────────────────────────
        if (!_isSignUp) ...[
          AppDimensions.spacing24.verticalSpace,
          PrimaryTextField(
            hintText: 'Password',
            headerText: 'Password',
            controller: _passwordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          AppDimensions.spacing8.verticalSpace,
          
          // ─────────────────────────────────────────────────────────
          // 🔗 FORGOT PASSWORD LİNKİ
          // ─────────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: isLoadingLogin ? null : () {
                  // TODO: Şifre sıfırlama sayfasına yönlendir
                },
                child: Text(
                  'Forgot Password?',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isLoadingLogin 
                        ? context.colorScheme.onSurfaceVariant.withOpacity(0.5)
                        : context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],

        // Sign Up modunda ekstra boşluk
        if (_isSignUp) AppDimensions.spacing16.verticalSpace,
      ],
    );
  }
}
