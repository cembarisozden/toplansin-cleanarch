/// Base Exception sınıfı
class AppException implements Exception {
  final String message;
  final int? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Sunucu exception
class ServerException extends AppException {
  const ServerException({super.message = 'Sunucu hatası', super.code});
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({super.message = 'Önbellek hatası', super.code});
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException({super.message = 'Ağ hatası', super.code});
}

/// Auth exception
class AuthException extends AppException {
  const AuthException({super.message = 'Kimlik doğrulama hatası', super.code});
}

