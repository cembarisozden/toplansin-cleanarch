// lib/domain/usecases/auth/sign_in_with_google_usecase.dart
//
// 📌 SignInWithGoogleUseCase - Google ile giriş/kayıt
// Parametre gerektirmez (NoParams), Google SDK kendi UI'ını açar.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/auth_repository.dart';

/// Google ile giriş use case'i
/// 
/// NoParams kullanılır çünkü Google SDK kendi hesap seçim
/// ekranını açar, bizden parametre beklemez.
@injectable
class SignInWithGoogleUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}

