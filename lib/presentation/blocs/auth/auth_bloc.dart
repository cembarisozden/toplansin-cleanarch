// lib/presentation/blocs/auth/auth_bloc.dart
//
// 📌 AuthBloc - Auth iş mantığının merkezi
//
// Bloc, Event'leri alır ve State'lere dönüştürür.
// Use Case'leri çağırarak domain katmanıyla iletişim kurar.
// UI ile doğrudan iletişim kurmaz, sadece state yayınlar.
//
// Akış:
// UI → Event → Bloc → UseCase → Repository → DataSource
//                ↓
// UI ← State ← Bloc
//
// 🔧 Kullanılan Teknikler:
// - Dart 3.0+ Pattern Matching (switch expression)
// - bloc_concurrency (droppable transformer)
// - isClosed kontrolü (memory leak önleme)

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/domain/usecases/auth/check_email_before_signup_usecase.dart';
import 'package:toplansin_cleanarch/domain/usecases/auth/sign_in_usecase.dart';
import 'package:toplansin_cleanarch/domain/usecases/auth/sign_in_with_apple_usecase.dart';
import 'package:toplansin_cleanarch/domain/usecases/auth/sign_in_with_google_usecase.dart';
import 'package:toplansin_cleanarch/domain/usecases/auth/sign_up_usecase.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_event.dart';
import 'package:toplansin_cleanarch/presentation/blocs/auth/auth_state.dart';

/// Auth işlemlerini yöneten Bloc
///
/// Injectable ile DI'a kaydedilir.
/// Use case'ler constructor'dan inject edilir.
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // ─────────────────────────────────────────────────────────────
  // 📦 DEPENDENCIES
  // ─────────────────────────────────────────────────────────────

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithAppleUseCase _signInWithAppleUseCase;
  final CheckEmailBeforeSignUpUseCase _checkEmailUseCase;
  final AppLogger _logger;

  // ─────────────────────────────────────────────────────────────
  // 🏗️ CONSTRUCTOR
  // ─────────────────────────────────────────────────────────────

  AuthBloc(
    this._signInUseCase,
    this._signUpUseCase,
    this._signInWithGoogleUseCase,
    this._signInWithAppleUseCase,
    this._checkEmailUseCase,
    this._logger,
  ) : super(const AuthState.initial()) {
    // 🔒 droppable(): Aynı event art arda gelirse sadece ilkini işle
    // Bu sayede kullanıcı butona birden fazla basarsa duplicate request önlenir
    on<LoginRequested>(_onLogin, transformer: droppable());
    on<SignUpRequested>(_onSignUp, transformer: droppable());
    on<CheckEmailRequested>(_onCheckEmail, transformer: droppable());
    on<GoogleSignInRequested>(_onGoogleSignIn, transformer: droppable());
    on<AppleSignInRequested>(_onAppleSignIn, transformer: droppable());
    on<SignOutRequested>(_onSignOut, transformer: droppable());
  }

  // ─────────────────────────────────────────────────────────────
  // 📧 EMAIL/ŞİFRE İŞLEMLERİ
  // ─────────────────────────────────────────────────────────────

  /// Email/şifre ile giriş
  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    _logger.debug('Login attempt: ${event.email}', tag: 'AuthBloc');
    emit(const AuthState.loading(action: AuthAction.login));

    // Önce email kontrolü yap
    final emailCheckResult = await _checkEmailUseCase(
      CheckEmailParams(email: event.email),
    );

    // Bloc kapatılmışsa emit yapma
    if (isClosed) return;

    // Pattern matching ile email kontrolü
    switch (emailCheckResult) {
      case Left(value: final failure):
        _logger.warning(
          'Email check failed: ${failure.message}',
          tag: 'AuthBloc',
        );
        emit(_mapFailureToState(failure));
        return;

      case Right(value: final emailCheck):
        // Email yoksa
        if (!emailCheck.exists) {
          _logger.warning('Email not found: ${event.email}', tag: 'AuthBloc');
          emit(
            AuthState.error(
              'Bu e-posta ile kayıtlı kullanıcı bulunamadı.',
              errorType: AuthErrorType.emailNotFound,
            ),
          );
          return;
        }

        final providers = emailCheck.providers;

        // Google ile kayıtlıysa hata göster
        if (providers.contains('google.com')) {
          _logger.warning(
            'Email registered with Google: ${event.email}',
            tag: 'AuthBloc',
          );
          emit(
            AuthState.error(
              'Bu e-posta Google ile kayıtlı. Lütfen Google ile giriş yapmayı deneyin.',
              errorType: AuthErrorType.accountExistsWithDifferentCredential,
            ),
          );
          return;
        }

        // Apple ile kayıtlıysa hata göster
        if (providers.contains('apple.com')) {
          _logger.warning(
            'Email registered with Apple: ${event.email}',
            tag: 'AuthBloc',
          );
          emit(
            AuthState.error(
              'Bu e-posta Apple ile kayıtlı. Lütfen Apple ile giriş yapmayı deneyin.',
              errorType: AuthErrorType.accountExistsWithDifferentCredential,
            ),
          );
          return;
        }

        // Password ile kayıtlıysa normal login yap
        if (providers.contains('password')) {
          _logger.debug(
            'Email registered with password, proceeding with login',
            tag: 'AuthBloc',
          );
          await _performLogin(event, emit);
        } else {
          // Bilinmeyen provider
          _logger.warning(
            'Unknown provider for email: ${event.email}',
            tag: 'AuthBloc',
          );
          emit(
            AuthState.error(
              'Bu e-posta ile giriş yapılamıyor.',
              errorType: AuthErrorType.unknown,
            ),
          );
        }
    }
  }

  /// Gerçek login işlemini yapar
  Future<void> _performLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    // Bloc kapatılmışsa emit yapma
    if (isClosed) return;

    // Pattern matching ile sonuç kontrolü
    switch (result) {
      case Left(value: final failure):
        _logger.warning('Login failed: ${failure.message}', tag: 'AuthBloc');
        emit(_mapFailureToState(failure));

      case Right(value: final user):
        _logger.info('Login successful: ${user.id}', tag: 'AuthBloc');
        emit(AuthState.authenticated(user));
    }
  }

  /// Yeni hesap oluşturma
  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    _logger.debug('Sign up attempt: ${event.email}', tag: 'AuthBloc');
    emit(const AuthState.loading(action: AuthAction.signUp));

    final result = await _signUpUseCase(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    // Bloc kapatılmışsa emit yapma
    if (isClosed) return;

    // Pattern matching ile sonuç kontrolü
    switch (result) {
      case Left(value: final failure):
        _logger.warning('Sign up failed: ${failure.message}', tag: 'AuthBloc');
        emit(_mapFailureToState(failure));

      case Right(value: final user):
        _logger.info('Sign up successful: ${user.id}', tag: 'AuthBloc');
        emit(AuthState.authenticated(user));
    }
  }

  /// Email kontrol (sign up öncesi)
  Future<void> _onCheckEmail(
    CheckEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.debug('Check email attempt: ${event.email}', tag: 'AuthBloc');
    emit(const AuthState.loading(action: AuthAction.checkEmail));

    final result = await _checkEmailUseCase(
      CheckEmailParams(email: event.email),
    );

    // Bloc kapatılmışsa emit yapma
    if (isClosed) return;

    // Pattern matching ile sonuç kontrolü
    switch (result) {
      case Left(value: final failure):
        _logger.warning(
          'Check email failed: ${failure.message}',
          tag: 'AuthBloc',
        );
        emit(_mapFailureToState(failure));

      case Right(value: final emailCheck):
        _logger.info(
          'Check email successful: exists=${emailCheck.exists}, providers=${emailCheck.providers}',
          tag: 'AuthBloc',
        );
        emit(AuthState.checkEmailSuccess(emailCheck));
    }
  }
  // ─────────────────────────────────────────────────────────────
  // 🔐 SOSYAL GİRİŞ İŞLEMLERİ
  // ─────────────────────────────────────────────────────────────

  /// Google ile giriş
  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.debug('Google sign in attempt', tag: 'AuthBloc');
    emit(const AuthState.loading(action: AuthAction.google));

    final result = await _signInWithGoogleUseCase(const NoParams());

    // Bloc kapatılmışsa emit yapma
    if (isClosed) return;

    // Pattern matching ile sonuç kontrolü
    switch (result) {
      case Left(value: final failure):
        _logger.warning(
          'Google sign in failed: ${failure.message}',
          tag: 'AuthBloc',
        );
        emit(_mapFailureToState(failure));

      case Right(value: final user):
        _logger.info('Google sign in successful: ${user.id}', tag: 'AuthBloc');
        emit(AuthState.authenticated(user));
    }
  }

  /// Apple ile giriş
  Future<void> _onAppleSignIn(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.debug('Apple sign in attempt', tag: 'AuthBloc');
    emit(const AuthState.loading(action: AuthAction.apple));

    final result = await _signInWithAppleUseCase(const NoParams());

    // Bloc kapatılmışsa emit yapma
    if (isClosed) return;

    // Pattern matching ile sonuç kontrolü
    switch (result) {
      case Left(value: final failure):
        _logger.warning(
          'Apple sign in failed: ${failure.message}',
          tag: 'AuthBloc',
        );
        emit(_mapFailureToState(failure));

      case Right(value: final user):
        _logger.info('Apple sign in successful: ${user.id}', tag: 'AuthBloc');
        emit(AuthState.authenticated(user));
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 🚪 ÇIKIŞ İŞLEMİ
  // ─────────────────────────────────────────────────────────────

  /// Oturumu kapat
  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    _logger.debug('Sign out attempt', tag: 'AuthBloc');
    emit(const AuthState.loading());

    // TODO: SignOutUseCase eklendiğinde burası güncellenecek
    emit(const AuthState.unauthenticated());
    _logger.info('Sign out successful', tag: 'AuthBloc');
  }

  // ─────────────────────────────────────────────────────────────
  // 🔄 FAILURE → STATE MAPPING
  // ─────────────────────────────────────────────────────────────

  /// Failure'ı AuthState.error'a dönüştürür
  AuthState _mapFailureToState(Failure failure) {
    if (failure is AuthFailure) {
      return AuthState.error(failure.message, errorType: failure.errorType);
    }
    return AuthState.error(failure.message);
  }
}
