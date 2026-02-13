import 'package:equatable/equatable.dart';

/// Base Failure sınıfı - tüm hatalar bundan türer
/// Domain Layer'da kullanılır, external dependency'lerden bağımsızdır
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

// ─────────────────────────────────────────────────────────────────────────────
// AUTH FAILURES
// ─────────────────────────────────────────────────────────────────────────────

/// Auth hata tipleri - Firebase'den bağımsız, generic enum
enum AuthErrorType {
  emailNotFound,      // Login: Email kayıtlı değil
  emailInUse,         // SignUp: Email zaten kullanımda
  invalidEmail,       // Format hatası
  wrongPassword,      // Şifre yanlış
  weakPassword,       // Şifre çok zayıf
  userDisabled,       // Hesap devre dışı
  tooManyRequests,    // Rate limit
  networkError,       // Ağ hatası
  cancelled,          // İşlem iptal edildi
  accountExistsWithDifferentCredential, // Email farklı provider ile kayıtlı
  unknown,            // Bilinmeyen hata
}

/// Kimlik doğrulama hatası
class AuthFailure extends Failure {
  final AuthErrorType errorType;
  
  const AuthFailure({
    super.message = 'Kimlik doğrulama hatası', 
    super.code,
    this.errorType = AuthErrorType.unknown,
  });

  /// Email ile ilgili hata mı? (TextField'da gösterilecek)
  bool get isEmailError => 
      errorType == AuthErrorType.emailNotFound ||
      errorType == AuthErrorType.emailInUse ||
      errorType == AuthErrorType.invalidEmail;
  
  /// Şifre ile ilgili hata mı?
  bool get isPasswordError =>
      errorType == AuthErrorType.wrongPassword ||
      errorType == AuthErrorType.weakPassword;
  
  /// Yeniden deneme yapılabilir mi?
  bool get isRetryable =>
      errorType == AuthErrorType.networkError ||
      errorType == AuthErrorType.tooManyRequests;
  
  @override
  List<Object?> get props => [message, code, errorType];
}

// ─────────────────────────────────────────────────────────────────────────────
// GENERAL FAILURES
// ─────────────────────────────────────────────────────────────────────────────

/// Sunucu hatası
class ServerFailure extends Failure {
  final String? errorCode;
  
  const ServerFailure({
    super.message = 'Sunucu hatası oluştu', 
    super.code,
    this.errorCode,
  });
  
  @override
  List<Object?> get props => [message, code, errorCode];
}

/// Bağlantı hatası
class NetworkFailure extends Failure {
  final NetworkErrorType errorType;
  
  const NetworkFailure({
    super.message = 'İnternet bağlantısı yok', 
    super.code,
    this.errorType = NetworkErrorType.noConnection,
  });
  
  @override
  List<Object?> get props => [message, code, errorType];
}

/// Network hata tipleri
enum NetworkErrorType {
  noConnection,       // İnternet yok
  timeout,            // Zaman aşımı
  connectionRefused,  // Bağlantı reddedildi
  hostNotFound,       // Sunucu bulunamadı
  sslError,           // SSL/TLS hatası
  unknown,            // Bilinmeyen
}

/// Timeout hatası
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'İşlem zaman aşımına uğradı', 
    super.code,
  });
}

/// Kayıt bulunamadı hatası
class NotFoundFailure extends Failure {
  final String? resourceType;
  
  const NotFoundFailure({
    super.message = 'Kayıt bulunamadı', 
    super.code,
    this.resourceType,
  });
  
  @override
  List<Object?> get props => [message, code, resourceType];
}

/// Storage hatası (Firebase Storage)
class StorageFailure extends Failure {
  final StorageErrorType errorType;
  
  const StorageFailure({
    super.message = 'Depolama hatası', 
    super.code,
    this.errorType = StorageErrorType.unknown,
  });
  
  @override
  List<Object?> get props => [message, code, errorType];
}

/// Storage hata tipleri
enum StorageErrorType {
  objectNotFound,     // Dosya bulunamadı
  bucketNotFound,     // Bucket bulunamadı
  quotaExceeded,      // Kota aşıldı
  unauthorized,       // Yetkisiz erişim
  cancelled,          // İptal edildi
  invalidChecksum,    // Dosya bozuk
  fileTooLarge,       // Dosya çok büyük
  unknown,            // Bilinmeyen
}

/// İzin hatası
class PermissionFailure extends Failure {
  final PermissionType permissionType;
  
  const PermissionFailure({
    super.message = 'İzin gerekli', 
    super.code,
    this.permissionType = PermissionType.unknown,
  });
  
  @override
  List<Object?> get props => [message, code, permissionType];
}

/// İzin tipleri
enum PermissionType {
  camera,             // Kamera
  gallery,            // Galeri
  location,           // Konum
  notification,       // Bildirim
  microphone,         // Mikrofon
  storage,            // Depolama
  contacts,           // Kişiler
  calendar,           // Takvim
  unknown,            // Bilinmeyen
}

/// Cache hatası
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Önbellek hatası', super.code});
}

/// Doğrulama hatası
class ValidationFailure extends Failure {
  final String? field;
  
  const ValidationFailure({
    super.message = 'Doğrulama hatası', 
    super.code,
    this.field,
  });
  
  @override
  List<Object?> get props => [message, code, field];
}

/// Format hatası
class FormatFailure extends Failure {
  const FormatFailure({
    super.message = 'Geçersiz veri formatı', 
    super.code,
  });
}

/// Bilinmeyen hata
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Bilinmeyen bir hata oluştu', super.code});
}
