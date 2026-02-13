// lib/presentation/blocs/auth/auth_state.dart
//
// 📌 AuthState - UI'ın dinlediği durumlar
//
// Freezed ile immutable state sınıfları oluşturuyoruz.
// Her state, ekranın o anki "fotoğrafı" gibi düşünülebilir.
// UI bu state'lere göre kendini yeniden çizer.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/domain/entities/email_check_entity.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Auth modülündeki tüm state'ler
/// 
/// UI'da kullanım örneği:
/// ```dart
/// BlocBuilder<AuthBloc, AuthState>(
///   builder: (context, state) {
///     return state.when(
///       initial: () => LoginForm(),
///       loading: () => CircularProgressIndicator(),
///       authenticated: (user) => HomePage(),
///       error: (message, errorType) => ErrorWidget(message),
///       unauthenticated: () => LoginForm(),
///     );
///   },
/// )
/// ```
@freezed
class AuthState with _$AuthState {
  // ─────────────────────────────────────────────────────────────
  // 🏁 BAŞLANGIÇ DURUMLARI
  // ─────────────────────────────────────────────────────────────
  
  /// Uygulama ilk açıldığında
  /// Henüz auth durumu kontrol edilmedi
  const factory AuthState.initial() = AuthInitial;

  /// Auth durumu kontrol edildi, kullanıcı giriş yapmamış
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  // ─────────────────────────────────────────────────────────────
  // ⏳ İŞLEM DURUMLARI
  // ─────────────────────────────────────────────────────────────
  
  /// İşlem devam ediyor (login, signup, google sign in vb.)
  /// UI'da loading spinner gösterilir
  const factory AuthState.loading({
    @Default(AuthAction.login) AuthAction action,
  }) = AuthLoading;

  // ─────────────────────────────────────────────────────────────
  // ✅ BAŞARI DURUMLARI
  // ─────────────────────────────────────────────────────────────
  
  /// Giriş başarılı, kullanıcı authenticated
  /// [user] → Giriş yapan kullanıcının bilgileri
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;



  const factory AuthState.checkEmailSuccess(EmailCheckEntity emailCheck) = AuthCheckEmailSuccess;


  // ─────────────────────────────────────────────────────────────
  // ❌ HATA DURUMLARI
  // ─────────────────────────────────────────────────────────────
  
  /// Bir hata oluştu
  /// [message] → Kullanıcıya gösterilecek hata mesajı
  /// [errorType] → Hata tipi (email hatası mı, şifre hatası mı vb.)
  const factory AuthState.error(
    String message, {
    @Default(AuthErrorType.unknown) AuthErrorType errorType,
  }) = AuthError;
  

  

}
  enum AuthAction {
    login,
    signUp,
    google,
    apple,
    checkEmail
  }