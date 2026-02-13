// lib/presentation/blocs/auth/auth_event.dart
//
// 📌 AuthEvent - Kullanıcının tetiklediği olaylar
// 
// Freezed ile immutable event sınıfları oluşturuyoruz.
// Her event, Bloc'a gönderilen bir "mesaj" gibi düşünülebilir.
// Bloc bu event'leri alır ve uygun state'e dönüştürür.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

/// Auth modülündeki tüm event'ler
/// 
/// Kullanım örneği:
/// ```dart
/// context.read<AuthBloc>().add(
///   AuthEvent.login(email: 'test@test.com', password: '123456'),
/// );
/// ```
@freezed
class AuthEvent with _$AuthEvent {
  // ─────────────────────────────────────────────────────────────
  // 📧 EMAIL/ŞİFRE İŞLEMLERİ
  // ─────────────────────────────────────────────────────────────
  
  /// Email ve şifre ile giriş
  const factory AuthEvent.login({
    required String email,
    required String password,
  }) = LoginRequested;

  /// Yeni hesap oluşturma (email + şifre + isim)
  const factory AuthEvent.signUp({
    required String email,
    required String password,
    required String name,
  }) = SignUpRequested;

  /// Email kontrol (sign up öncesi)
  /// Email'in kayıtlı olup olmadığını ve hangi provider ile kayıtlı olduğunu kontrol eder
  const factory AuthEvent.checkEmail({
    required String email,
  }) = CheckEmailRequested;

  // ─────────────────────────────────────────────────────────────
  // 🔐 SOSYAL GİRİŞ İŞLEMLERİ
  // ─────────────────────────────────────────────────────────────
  
  /// Google ile giriş/kayıt
  /// Parametre yok - Google SDK kendi hesap seçim ekranını açar
  const factory AuthEvent.signInWithGoogle() = GoogleSignInRequested;

  /// Apple ile giriş/kayıt
  /// iOS cihazlarda App Store kuralı gereği zorunlu
  const factory AuthEvent.signInWithApple() = AppleSignInRequested;

  // ─────────────────────────────────────────────────────────────
  // 🚪 ÇIKIŞ İŞLEMİ
  // ─────────────────────────────────────────────────────────────
  
  /// Oturumu kapat
  const factory AuthEvent.signOut() = SignOutRequested;
}

