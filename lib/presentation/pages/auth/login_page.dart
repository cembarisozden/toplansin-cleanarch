// lib/presentation/pages/auth/login_page.dart
//
// 📌 LoginPage - Giriş/Kayıt ekranı
//
// AuthBloc app seviyesinde provide edilir (app.dart).
// BlocConsumer ile state değişiklikleri ve yan etkiler yönetilir.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/extensions/string_extensions.dart';
import 'package:toplansin_cleanarch/core/router/route_names.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_bloc.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_event.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_state.dart';
import 'package:toplansin_cleanarch/presentation/pages/auth/sections/login_bottom_section.dart';
import 'package:toplansin_cleanarch/presentation/pages/auth/sections/login_header_section.dart';
import 'package:toplansin_cleanarch/presentation/pages/auth/sections/login_body_section.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // ─────────────────────────────────────────────────────────────
  // 🎮 CONTROLLERS
  // ─────────────────────────────────────────────────────────────
  late TabController _tabController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ─────────────────────────────────────────────────────────────
  // 📊 LOCAL STATE
  // ─────────────────────────────────────────────────────────────
  bool _isSignUp = false;

  /// Client-side email format hatası
  String? _localEmailError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _isSignUp = _tabController.index == 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─────────────────────────────────────────────────────────
          // 🖼️ BACKGROUND IMAGE
          // ─────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            height: 300.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ─────────────────────────────────────────────────────────
          // 📱 MAIN CONTENT
          // ─────────────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimensions.spacing28.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: const LoginHeaderSection(),
                ),
                AppDimensions.spacing24.verticalSpace,

                // ─────────────────────────────────────────────────────
                // 🔲 BLOC CONSUMER - Listener + Builder birlikte
                // ─────────────────────────────────────────────────────
                Expanded(
                  child: BlocConsumer<AuthBloc, AuthState>(
                    // 👂 LISTENER: Side effects (navigation, snackbar)
                    listener: _handleStateChanges,

                    // 🎨 BUILDER: UI
                    builder: (context, state) {
                      return _buildContent(context, state);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 👂 STATE CHANGE HANDLER (Listener)
  // ─────────────────────────────────────────────────────────────

  void _handleStateChanges(BuildContext context, AuthState state) {
    state.when(
      initial: () {},
      loading: (action) {},
      checkEmailSuccess: (emailCheck) {
        if (!emailCheck.exists) {
          // Email yoksa continueSignUp sayfasına git
          final email = _emailController.text.trim();
          context.pushNamed(
            RouteNames.continueSignUp,
            queryParameters: {'email': email},
          );
        } else {
          // Email varsa kullanıcıya bilgi ver
          final providers = emailCheck.providers;
          final providerText = providers.contains('google.com')
              ? 'Google'
              : providers.contains('password')
                  ? 'E-posta/Şifre'
                  : 'farklı bir yöntem';
          context.showErrorSnackBar(
            'Bu e-posta adresi $providerText ile kayıtlı. Lütfen giriş yapın.',
          );
        }
      },
      authenticated: (user) {
        context.pushNamed(RouteNames.home);
        context.showSuccessSnackBar(
          'Hoşgeldin ${user.displayName ?? user.email}!',
        );
      },
      error: (message, errorType) {
        // İptal durumunda info snackbar göster
        if (errorType == AuthErrorType.cancelled) {
          context.showInfoSnackBar(message);
          return;
        }

        // Farklı provider ile kayıtlı email için özel mesaj
        if (errorType == AuthErrorType.accountExistsWithDifferentCredential) {
          context.showErrorSnackBar(message);
          return;
        }

        // Email hatası değilse snackbar göster
        // Email hataları TextField'da gösterilecek
        if (!_isEmailError(errorType)) {
          context.showErrorSnackBar(message);
        }
      },
      unauthenticated: () {},
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🎨 CONTENT BUILDER
  // ─────────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, AuthState state) {
    // Email error: Local veya API (email-specific)
    String? emailError = _localEmailError;
    if (emailError == null && state is AuthError) {
      if (_isEmailError(state.errorType)) {
        emailError = state.message;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusLg),
          topRight: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDimensions.spacing16.verticalSpace,

            // Form alanları
            LoginBodySection(
              tabController: _tabController,
              emailController: _emailController,
              passwordController: _passwordController,
              isSignUp: _isSignUp,
              isLoadingSignUp: state is AuthLoading
                  ? state.action == AuthAction.checkEmail
                  : false,
              isLoadingLogin: state is AuthLoading
                  ? state.action == AuthAction.login
                  : false,
              errorMessage: emailError,
            ),

            AppDimensions.spacing8.verticalSpace,

            // Butonlar
            LoginBottomSection(
              isSignUp: _isSignUp,
              isLoadingLogin: state is AuthLoading
                  ? state.action == AuthAction.login
                  : false,
              isLoadingGoogle: state is AuthLoading
                  ? state.action == AuthAction.google
                  : false,
              isLoadingApple: state is AuthLoading
                  ? state.action == AuthAction.apple
                  : false,
              onLogInTap: () => _handleAuthAction(context),
              onGoogleTap: () => context.read<AuthBloc>().add(
                    const AuthEvent.signInWithGoogle(),
                  ),
              onAppleTap: () => context.read<AuthBloc>().add(
                    const AuthEvent.signInWithApple(),
                  ),
            ),

            AppDimensions.spacing16.verticalSpace,
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🎬 ACTIONS
  // ─────────────────────────────────────────────────────────────

  /// Login veya Sign Up işlemini başlat
  void _handleAuthAction(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Client-side email validation
    if (email.isEmpty) {
      setState(() => _localEmailError = 'E-posta adresi giriniz');
      return;
    }

    if (!email.isValidEmail) {
      setState(() => _localEmailError = 'Geçersiz e-posta formatı');
      return;
    }

    setState(() => _localEmailError = null);

    if (_isSignUp) {
      context.read<AuthBloc>().add(AuthEvent.checkEmail(email: email));
    } else {
      context.read<AuthBloc>().add(
        AuthEvent.login(email: email, password: password),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 🔍 HELPERS
  // ─────────────────────────────────────────────────────────────

  /// Email ile ilgili hata mı kontrol et
  /// Bu hatalar TextField'da gösterilir, diğerleri snackbar'da
  bool _isEmailError(AuthErrorType errorType) {
    return errorType == AuthErrorType.emailNotFound ||
        errorType == AuthErrorType.emailInUse ||
        errorType == AuthErrorType.invalidEmail;
  }
}
