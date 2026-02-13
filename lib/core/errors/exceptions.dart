/// Base Exception sınıfı - Data Layer'da kullanılır
/// DataSource'lar bu exception'ları fırlatır
/// Repository'ler yakalar ve Failure'a dönüştürür
abstract class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

// ─────────────────────────────────────────────────────────────────────────────
// AUTH EXCEPTIONS
// ─────────────────────────────────────────────────────────────────────────────

/// Auth exception - Firebase Auth hatalarını wrap eder
class AuthException extends AppException {
  /// Original error code (Firebase: user-not-found, email-already-in-use vb.)
  final String? errorCode;
  
  const AuthException({
    super.message = 'Kimlik doğrulama hatası', 
    super.code,
    this.errorCode,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// GENERAL EXCEPTIONS
// ─────────────────────────────────────────────────────────────────────────────

/// Sunucu exception
class ServerException extends AppException {
  final String? errorCode;
  
  const ServerException({
    super.message = 'Sunucu hatası', 
    super.code,
    this.errorCode,
  });
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({super.message = 'Önbellek hatası', super.code});
}

/// Network exception - İnternet bağlantısı hataları
class NetworkException extends AppException {
  final String? errorCode;
  
  const NetworkException({
    super.message = 'Ağ hatası', 
    super.code,
    this.errorCode,
  });
}

/// Timeout exception - Zaman aşımı hataları
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'İşlem zaman aşımına uğradı', 
    super.code,
  });
}

/// NotFound exception - Kayıt bulunamadı
class NotFoundException extends AppException {
  final String? errorCode;
  
  const NotFoundException({
    super.message = 'Kayıt bulunamadı', 
    super.code,
    this.errorCode,
  });
}

/// Storage exception - Firebase Storage hataları
class StorageException extends AppException {
  final String? errorCode;
  
  const StorageException({
    super.message = 'Depolama hatası', 
    super.code,
    this.errorCode,
  });
}

/// Permission exception - İzin hataları (kamera, lokasyon vb.)
class PermissionException extends AppException {
  final String? permissionType;
  
  const PermissionException({
    super.message = 'İzin hatası', 
    super.code,
    this.permissionType,
  });
}

/// Validation exception - Doğrulama hataları
class ValidationException extends AppException {
  final String? field;
  
  const ValidationException({
    super.message = 'Doğrulama hatası', 
    super.code,
    this.field,
  });
}

/// Format exception - Veri formatı hataları
class FormatException extends AppException {
  const FormatException({
    super.message = 'Geçersiz veri formatı', 
    super.code,
  });
}
