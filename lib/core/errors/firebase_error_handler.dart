import 'dart:async' as async;
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'exceptions.dart';

/// Firebase ve platform hatalarını AppException'a dönüştüren merkezi handler
/// Data Layer'da kullanılır, Repository'ye Exception fırlatır
/// 
/// Kullanım:
/// ```dart
/// try {
///   await firebaseOperation();
/// } catch (e) {
///   throw FirebaseErrorHandler.handle(e);
/// }
/// ```
class FirebaseErrorHandler {
  const FirebaseErrorHandler._();

  // ─────────────────────────────────────────────────────────────────────────────
  // MAIN HANDLER
  // ─────────────────────────────────────────────────────────────────────────────

  /// Herhangi bir hatayı uygun AppException'a dönüştürür
  static AppException handle(Object error) {
    // Zaten AppException ise aynen döndür
    if (error is AppException) return error;

    // Firebase Auth hataları
    if (error is FirebaseAuthException) {
      return _handleAuthError(error);
    }

    // Firebase Storage hataları
    if (error is FirebaseException && error.plugin == 'firebase_storage') {
      return _handleStorageError(error);
    }

    // Firestore/Firebase Core hataları
    if (error is FirebaseException) {
      return _handleFirestoreError(error);
    }

    // Cloud Functions hataları
    if (error is FirebaseFunctionsException) {
      return _handleFunctionsError(error);
    }

    // Google Sign-In hataları
    if (error is GoogleSignInException) {
      return _handleGoogleSignInError(error);
    }

    // Apple Sign-In hataları
    if (error is SignInWithAppleAuthorizationException) {
      return _handleAppleError(error);
    }

    // Network hataları
    if (error is SocketException) {
      return _handleSocketError(error);
    }

    // Timeout hataları
    if (error is async.TimeoutException) {
      return _handleTimeoutError(error);
    }

    // HTTP hataları
    if (error is HttpException) {
      return _handleHttpError(error);
    }

    // TLS/SSL hataları
    if (error is TlsException || error is HandshakeException) {
      return NetworkException(
        message: 'Güvenli bağlantı kurulamadı',
        errorCode: 'ssl_error',
      );
    }

    // Format hataları
    if (error is FormatException) {
      return const FormatException(message: 'Geçersiz veri formatı');
    }

    // Bilinmeyen hata
    return ServerException(
      message: error.toString(),
      errorCode: 'unknown',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FIREBASE AUTH ERRORS
  // ─────────────────────────────────────────────────────────────────────────────

  /// FirebaseAuth hataları → AuthException
  static AuthException _handleAuthError(FirebaseAuthException e) {
    final message = switch (e.code) {
      // Email/Password hataları
      'user-not-found' => 'Kullanıcı bulunamadı',
      'wrong-password' => 'Hatalı şifre',
      'email-already-in-use' => 'Bu e-posta zaten kullanımda',
      'invalid-email' => 'Geçersiz e-posta adresi',
      'weak-password' => 'Şifre en az 6 karakter olmalı',
      'user-disabled' => 'Bu hesap devre dışı bırakılmış',
      'invalid-credential' => 'Geçersiz kimlik bilgisi',
      
      // Rate limiting
      'too-many-requests' => 'Çok fazla deneme. Lütfen bekleyin',
      
      // Credential hataları
      'account-exists-with-different-credential' =>
        'Bu e-posta farklı bir giriş yöntemiyle kayıtlı',
      'credential-already-in-use' => 'Bu kimlik bilgisi başka bir hesapla ilişkili',
      'invalid-verification-code' => 'Geçersiz doğrulama kodu',
      'invalid-verification-id' => 'Geçersiz doğrulama ID',
      
      // Session hataları
      'requires-recent-login' => 'Lütfen tekrar giriş yapın',
      'user-token-expired' => 'Oturum süresi doldu. Tekrar giriş yapın',
      'session-expired' => 'Oturum süresi doldu',
      
      // Provider hataları
      'operation-not-allowed' => 'Bu giriş yöntemi etkin değil',
      'provider-already-linked' => 'Bu hesap zaten bağlı',
      'no-such-provider' => 'Bu giriş yöntemi hesaba bağlı değil',
      
      // Network
      'network-request-failed' => 'İnternet bağlantısını kontrol edin',
      
      // Diğer
      'user-mismatch' => 'Hesap uyuşmazlığı',
      'expired-action-code' => 'Bağlantı süresi dolmuş',
      'invalid-action-code' => 'Geçersiz bağlantı',
      
      _ => e.message ?? 'Kimlik doğrulama hatası',
    };

    return AuthException(
      message: message,
      code: e.code.hashCode,
      errorCode: e.code,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // GOOGLE SIGN-IN ERRORS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Google Sign-In hataları → AuthException
  static AuthException _handleGoogleSignInError(GoogleSignInException e) {
    final errorString = e.toString();
    final message = switch (e.code) {
      GoogleSignInExceptionCode.unknownError =>
        errorString.contains('No credential')
            ? 'Google hesabı seçilmedi veya kimlik bilgisi alınamadı'
            : errorString.toLowerCase().contains('network')
            ? 'İnternet bağlantısını kontrol edin'
            : 'Google ile giriş başarısız',
      GoogleSignInExceptionCode.canceled => 'Google ile giriş iptal edildi',
      GoogleSignInExceptionCode.clientConfigurationError =>
        'Google yapılandırma hatası',
      GoogleSignInExceptionCode.interrupted =>
        'Google giriş işlemi kesintiye uğradı',
      GoogleSignInExceptionCode.providerConfigurationError =>
        'Google sağlayıcı yapılandırma hatası',
      GoogleSignInExceptionCode.uiUnavailable =>
        'Google giriş ekranı kullanılamıyor',
      GoogleSignInExceptionCode.userMismatch => 'Google hesap uyuşmazlığı',
    };

    return AuthException(
      message: message,
      code: e.code.hashCode,
      errorCode: e.code.toString(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // APPLE SIGN-IN ERRORS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Apple Sign-In hataları → AuthException
  static AuthException _handleAppleError(SignInWithAppleAuthorizationException e) {
    final message = switch (e.code) {
      AuthorizationErrorCode.canceled => 'Apple ile giriş iptal edildi',
      AuthorizationErrorCode.failed => 'Apple ile giriş başarısız oldu',
      AuthorizationErrorCode.invalidResponse => 'Apple sunucusundan geçersiz yanıt',
      AuthorizationErrorCode.notHandled => 'İstek işlenemedi',
      AuthorizationErrorCode.notInteractive => 'Etkileşimli giriş gerekli',
      AuthorizationErrorCode.unknown => 'Bilinmeyen bir Apple giriş hatası',
      _ => 'Apple ile giriş yapılamadı',
    };

    return AuthException(
      message: message,
      code: e.code.hashCode,
      errorCode: e.code.toString(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FIRESTORE ERRORS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Firestore hataları → ServerException / NotFoundException
  static AppException _handleFirestoreError(FirebaseException e) {
    // Not found için özel exception
    if (e.code == 'not-found') {
      return NotFoundException(
        message: 'Kayıt bulunamadı',
        errorCode: e.code,
      );
    }

    final message = switch (e.code) {
      // Yetki hataları
      'permission-denied' => 'Bu işlem için yetkiniz yok',
      'unauthenticated' => 'Oturum açmanız gerekiyor',
      
      // Veri hataları
      'already-exists' => 'Bu kayıt zaten mevcut',
      'invalid-argument' => 'Geçersiz veri',
      'out-of-range' => 'Değer aralık dışında',
      
      // İşlem hataları
      'failed-precondition' => 'İşlem şartları sağlanmadı',
      'aborted' => 'İşlem iptal edildi',
      'cancelled' => 'İşlem iptal edildi',
      
      // Kaynak hataları
      'resource-exhausted' => 'İstek limiti aşıldı. Lütfen bekleyin',
      'data-loss' => 'Veri kaybı oluştu',
      
      // Bağlantı hataları
      'unavailable' => 'Sunucu şu an kullanılamıyor',
      'deadline-exceeded' => 'İşlem zaman aşımına uğradı',
      'internal' => 'Sunucu hatası oluştu',
      'unknown' => 'Bilinmeyen bir hata oluştu',
      
      _ => e.message ?? 'Sunucu hatası',
    };

    return ServerException(
      message: message,
      code: e.code.hashCode,
      errorCode: e.code,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FIREBASE STORAGE ERRORS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Firebase Storage hataları → StorageException
  static StorageException _handleStorageError(FirebaseException e) {
    final message = switch (e.code) {
      // Dosya hataları
      'object-not-found' => 'Dosya bulunamadı',
      'bucket-not-found' => 'Depolama alanı bulunamadı',
      'project-not-found' => 'Proje bulunamadı',
      
      // Yetki hataları
      'unauthorized' => 'Bu dosyaya erişim yetkiniz yok',
      'unauthenticated' => 'Dosyaya erişmek için giriş yapmalısınız',
      
      // Kota hataları
      'quota-exceeded' => 'Depolama kotası aşıldı',
      'retry-limit-exceeded' => 'Çok fazla deneme yapıldı',
      
      // İşlem hataları
      'canceled' => 'Yükleme iptal edildi',
      'invalid-checksum' => 'Dosya bozuk veya eksik',
      'invalid-event-name' => 'Geçersiz işlem',
      
      // Boyut hataları
      'invalid-url' => 'Geçersiz dosya adresi',
      'invalid-argument' => 'Geçersiz dosya parametresi',
      'no-default-bucket' => 'Varsayılan depolama alanı yapılandırılmamış',
      
      // Bağlantı
      'cannot-slice-blob' => 'Dosya işlenemedi',
      'server-file-wrong-size' => 'Dosya boyutu uyuşmuyor',
      
      _ => e.message ?? 'Depolama hatası',
    };

    return StorageException(
      message: message,
      errorCode: e.code,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CLOUD FUNCTIONS ERRORS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Cloud Functions hataları → ServerException
  static ServerException _handleFunctionsError(FirebaseFunctionsException e) {
    final message = switch (e.code) {
      // Yetki
      'unauthenticated' => 'Oturum açmanız gerekiyor',
      'permission-denied' => 'Bu işlem için yetkiniz yok',
      
      // Veri
      'not-found' => 'İşlev bulunamadı',
      'invalid-argument' => 'Geçersiz parametre',
      'out-of-range' => 'Parametre aralık dışında',
      'already-exists' => 'Kayıt zaten mevcut',
      
      // İşlem
      'failed-precondition' => 'İşlem şartları sağlanmadı',
      'aborted' => 'İşlem iptal edildi',
      'cancelled' => 'İşlem iptal edildi',
      
      // Kaynak
      'resource-exhausted' => 'İstek limiti aşıldı',
      'deadline-exceeded' => 'İşlem zaman aşımına uğradı',
      
      // Sunucu
      'unavailable' => 'Servis şu an kullanılamıyor',
      'internal' => 'Sunucu hatası',
      'unimplemented' => 'Bu özellik henüz desteklenmiyor',
      'data-loss' => 'Veri kaybı oluştu',
      'unknown' => 'Bilinmeyen hata',
      
      _ => e.message ?? 'İşlem hatası',
    };

    return ServerException(
      message: message,
      code: e.code.hashCode,
      errorCode: e.code,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // NETWORK ERRORS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Socket hataları → NetworkException
  static NetworkException _handleSocketError(SocketException e) {
    final message = switch (e.osError?.errorCode) {
      // Bağlantı yok
      7 || 101 || 110 => 'İnternet bağlantısı yok',
      
      // Bağlantı reddedildi
      111 || 61 => 'Sunucuya bağlanılamadı',
      
      // DNS hatası
      8 || 11001 => 'Sunucu adresi çözümlenemedi',
      
      // Timeout
      60 || 110 => 'Bağlantı zaman aşımına uğradı',
      
      // Bağlantı kesildi
      104 || 54 => 'Bağlantı kesildi',
      
      _ => 'İnternet bağlantısını kontrol edin',
    };

    return NetworkException(
      message: message,
      errorCode: 'socket_error_${e.osError?.errorCode}',
    );
  }

  /// Timeout hataları → TimeoutException
  static TimeoutException _handleTimeoutError(async.TimeoutException e) {
    final duration = e.duration;
    final message = duration != null
        ? 'İşlem ${duration.inSeconds} saniye içinde tamamlanamadı'
        : 'İşlem zaman aşımına uğradı';

    return TimeoutException(message: message);
  }

  /// HTTP hataları → ServerException / NetworkException
  static AppException _handleHttpError(HttpException e) {
    final message = e.message.toLowerCase();

    if (message.contains('connection') || message.contains('network')) {
      return NetworkException(
        message: 'Bağlantı hatası oluştu',
        errorCode: 'http_connection_error',
      );
    }

    return ServerException(
      message: 'HTTP hatası: ${e.message}',
      errorCode: 'http_error',
    );
  }
}
