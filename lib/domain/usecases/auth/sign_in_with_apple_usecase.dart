// lib/domain/usecases/auth/sign_in_with_apple_usecase.dart
//
// 📌 SignInWithAppleUseCase - Apple ile giriş/kayıt
// Parametre gerektirmez (NoParams), Apple SDK kendi UI'ını açar.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/auth_repository.dart';

/// Apple ile giriş use case'i
/// 
/// iOS cihazlarda zorunlu (App Store kuralı).
/// NoParams kullanılır çünkü Apple SDK kendi UI'ını açar.
@injectable
class SignInWithAppleUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  SignInWithAppleUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return _repository.signInWithApple();
  }
}

