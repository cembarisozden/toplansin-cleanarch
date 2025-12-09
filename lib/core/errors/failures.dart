import 'package:equatable/equatable.dart';

/// Base Failure sınıfı - tüm hatalar bundan türer
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Sunucu hatası
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Sunucu hatası oluştu', super.code});
}

/// Bağlantı hatası
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'İnternet bağlantısı yok', super.code});
}

/// Cache hatası
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Önbellek hatası', super.code});
}

/// Kimlik doğrulama hatası
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Kimlik doğrulama hatası', super.code});
}

/// Doğrulama hatası
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Doğrulama hatası', super.code});
}

/// Bilinmeyen hata
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Bilinmeyen bir hata oluştu', super.code});
}

