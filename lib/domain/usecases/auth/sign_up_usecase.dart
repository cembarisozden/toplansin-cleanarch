// lib/domain/usecases/auth/sign_up_usecase.dart
//
// 📌 SignUpUseCase - Yeni kullanıcı kaydı
// Email, şifre ve isim alarak yeni hesap oluşturur.

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/auth_repository.dart';

/// Yeni kullanıcı kaydı use case'i
@injectable
class SignUpUseCase extends UseCase<UserEntity, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    // Repository'nin signUp metodunu çağır
    return _repository.signUp(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

/// SignUp için gerekli parametreler
class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

