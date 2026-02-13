// lib/presentation/pages/auth/continue_sign_up_page.dart
//
// 📌 ContinueSignUpPage - Kayıt tamamlama sayfası
//
// İsim, şifre ve şifre onaylama alanları içerir.
// Email önceki sayfadan gelir ve değiştirilemez.
// AuthBloc app seviyesinde provide edilir (app.dart).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:toplansin_cleanarch/core/extensions/context_extensions.dart';
import 'package:toplansin_cleanarch/core/theme/app_dimensions.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_bloc.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_event.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_state.dart';
import 'package:toplansin_cleanarch/presentation/widgets/primary_button.dart';
import 'package:toplansin_cleanarch/presentation/widgets/primary_text_field.dart';

class ContinueSignUpPage extends StatefulWidget {
  const ContinueSignUpPage({super.key});

  @override
  State<ContinueSignUpPage> createState() => _ContinueSignUpPageState();
}

class _ContinueSignUpPageState extends State<ContinueSignUpPage> {
  // ─────────────────────────────────────────────────────────────
  // 🎮 CONTROLLERS
  // ─────────────────────────────────────────────────────────────
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // ─────────────────────────────────────────────────────────────
  // 📊 LOCAL STATE
  // ─────────────────────────────────────────────────────────────
  String? _nameError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _emailInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Email'i query parameter'dan al (sadece bir kez)
    if (!_emailInitialized) {
      final email = GoRouterState.of(context).uri.queryParameters['email'] ?? '';
      _emailController.text = email;
      _emailInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // 👂 LISTENER: Side effects (navigation, snackbar)
      listener: _handleStateChanges,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Kayıt Ol',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimensions.spacing24.verticalSpace,

                // ─────────────────────────────────────────────────────
                // 📧 EMAIL FIELD (Read-only)
                // ─────────────────────────────────────────────────────
                _buildEmailField(context),

                AppDimensions.spacing16.verticalSpace,

                // ─────────────────────────────────────────────────────
                // 👤 NAME FIELD
                // ─────────────────────────────────────────────────────
                PrimaryTextField(
                  controller: _nameController,
                  hintText: 'Adınızı giriniz',
                  keyboardType: TextInputType.name,
                  headerText: 'İsim',
                  hasError: _nameError != null,
                  errorMessage: _nameError,
                ),

                AppDimensions.spacing16.verticalSpace,

                // ─────────────────────────────────────────────────────
                // 🔒 PASSWORD FIELD
                // ─────────────────────────────────────────────────────
                PrimaryTextField(
                  controller: _passwordController,
                  hintText: 'Şifrenizi giriniz',
                  obscureText: true,
                  headerText: 'Şifre',
                  hasError: _passwordError != null,
                  errorMessage: _passwordError,
                ),

                AppDimensions.spacing16.verticalSpace,

                // ─────────────────────────────────────────────────────
                // 🔒 CONFIRM PASSWORD FIELD
                // ─────────────────────────────────────────────────────
                PrimaryTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Şifrenizi tekrar giriniz',
                  obscureText: true,
                  headerText: 'Şifre Onay',
                  hasError: _confirmPasswordError != null,
                  errorMessage: _confirmPasswordError,
                ),

                AppDimensions.spacing32.verticalSpace,

                // ─────────────────────────────────────────────────────
                // ✅ SUBMIT BUTTON
                // ─────────────────────────────────────────────────────
                _buildSubmitButton(context),

                AppDimensions.spacing24.verticalSpace,
              ],
            ),
          ),
        ),
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
      checkEmailSuccess: (emailCheck) {},
      authenticated: (user) {
        // TODO: Ana sayfaya yönlendir
        context.showSuccessSnackBar(
          'Hoşgeldin ${user.displayName ?? user.email}!',
        );
      },
      error: (message, errorType) {
        context.showErrorSnackBar(message);
      },
      unauthenticated: () {},
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🎨 UI COMPONENTS
  // ─────────────────────────────────────────────────────────────

  Widget _buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'E-posta',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        AppDimensions.spacing4.verticalSpace,
        TextField(
          controller: _emailController,
          enabled: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'E-posta adresiniz',
            filled: true,
            fillColor: context.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              borderSide: BorderSide(
                color: context.colorScheme.outline,
              ),
            ),
            labelStyle: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) =>
          state is AuthLoading && state.action == AuthAction.signUp,
      builder: (context, isLoading) {
        return PrimaryButton(
          onPressed: isLoading ? null : () => _handleSubmit(context),
          label: 'Kayıt Ol',
          isLoading: isLoading,
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🎬 ACTIONS
  // ─────────────────────────────────────────────────────────────

  /// Form submit işlemi
  void _handleSubmit(BuildContext context) {
    // Validation
    setState(() {
      _nameError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    final name = _nameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    bool hasError = false;

    if (name.isEmpty) {
      setState(() => _nameError = 'İsim giriniz');
      hasError = true;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = 'Şifre giriniz');
      hasError = true;
    } else if (password.length < 6) {
      setState(() => _passwordError = 'Şifre en az 6 karakter olmalıdır');
      hasError = true;
    }

    if (confirmPassword.isEmpty) {
      setState(() => _confirmPasswordError = 'Şifre onayını giriniz');
      hasError = true;
    } else if (password != confirmPassword) {
      setState(() => _confirmPasswordError = 'Şifreler eşleşmiyor');
      hasError = true;
    }

    if (hasError) return;

    context.read<AuthBloc>().add(AuthEvent.signUp(email: _emailController.text.trim(), password: password, name: name));
    
    context.unfocus();
  }
}