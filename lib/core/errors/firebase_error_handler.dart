import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'failures.dart';

/// Firebase hatalarını Failure'a dönüştüren merkezi handler
class FirebaseErrorHandler {
  const FirebaseErrorHandler._();

  /// Herhangi bir Firebase hatasını uygun Failure'a dönüştürür
  static Failure handle(Object error) {
    if (error is FirebaseAuthException) {
      return _handleAuthError(error);
    }
    if (error is FirebaseException) {
      return _handleFirestoreError(error);
    }
    if (error is FirebaseFunctionsException) {
      return _handleFunctionsError(error);
    }
    return UnknownFailure(message: error.toString());
  }

  /// FirebaseAuth hataları
  static AuthFailure _handleAuthError(FirebaseAuthException e) {
    final message = switch (e.code) {
      'user-not-found' => 'Kullanıcı bulunamadı',
      'wrong-password' => 'Hatalı şifre',
      'email-already-in-use' => 'Bu e-posta zaten kullanımda',
      'invalid-email' => 'Geçersiz e-posta adresi',
      'weak-password' => 'Şifre en az 6 karakter olmalı',
      'user-disabled' => 'Bu hesap devre dışı bırakılmış',
      'too-many-requests' => 'Çok fazla deneme. Lütfen bekleyin',
      'operation-not-allowed' => 'Bu işlem şu an kullanılamıyor',
      'invalid-credential' => 'Geçersiz kimlik bilgisi',
      'account-exists-with-different-credential' => 
          'Bu e-posta farklı bir giriş yöntemiyle kayıtlı',
      'requires-recent-login' => 'Lütfen tekrar giriş yapın',
      'network-request-failed' => 'İnternet bağlantısını kontrol edin',
      _ => e.message ?? 'Kimlik doğrulama hatası',
    };
    return AuthFailure(message: message, code: e.code.hashCode);
  }

  /// Firestore hataları
  static ServerFailure _handleFirestoreError(FirebaseException e) {
    final message = switch (e.code) {
      'permission-denied' => 'Bu işlem için yetkiniz yok',
      'not-found' => 'Kayıt bulunamadı',
      'already-exists' => 'Bu kayıt zaten mevcut',
      'resource-exhausted' => 'İstek limiti aşıldı',
      'failed-precondition' => 'İşlem şartları sağlanmadı',
      'aborted' => 'İşlem iptal edildi',
      'unavailable' => 'Sunucu şu an kullanılamıyor',
      'deadline-exceeded' => 'İşlem zaman aşımına uğradı',
      'cancelled' => 'İşlem iptal edildi',
      _ => e.message ?? 'Sunucu hatası',
    };
    return ServerFailure(message: message, code: e.code.hashCode);
  }

   // Cloud Functions hataları (gerekirse aç)
   static Failure _handleFunctionsError(FirebaseFunctionsException e) {
     final message = switch (e.code) {
       'unauthenticated' => 'Oturum açmanız gerekiyor',
       'permission-denied' => 'Bu işlem için yetkiniz yok',
       'not-found' => 'İşlev bulunamadı',
       'invalid-argument' => 'Geçersiz parametre',
       'resource-exhausted' => 'İstek limiti aşıldı',
       _ => e.message ?? 'İşlem hatası',
     };
     return ServerFailure(message: message, code: e.code.hashCode);
   }
}
