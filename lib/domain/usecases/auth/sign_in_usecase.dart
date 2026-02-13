// lib/domain/usecases/auth/sign_in_usecase.dart
//
// 📌 SignInUseCase - Email/şifre ile giriş yapma işlemi
// Clean Architecture'da Use Case, tek bir iş mantığını temsil eder.
// Repository'yi çağırır ve sonucu döner.

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/auth_repository.dart';

/// Email/şifre ile giriş yapma use case'i
/// 
/// Kullanım:
/// ```dart
/// final result = await signInUseCase(SignInParams(email: 'x', password: 'y'));
/// result.fold(
///   (failure) => print(failure.message),
///   (user) => print('Hoşgeldin ${user.displayName}'),
/// );
/// ```
@injectable
class SignInUseCase extends UseCase<UserEntity, SignInParams> {
  // Repository dependency injection ile gelir
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    // Repository'nin signIn metodunu çağır
    // Either<Failure, UserEntity> döner:
    // - Left(Failure) → Hata durumu
    // - Right(UserEntity) → Başarılı giriş
    return _repository.signIn(params.email, params.password);
  }
}

/// SignIn için gerekli parametreler
/// Equatable ile eşitlik kontrolü sağlanır (test için faydalı)
class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

