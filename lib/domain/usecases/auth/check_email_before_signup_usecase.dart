// lib/domain/usecases/auth/check_email_before_signup_usecase.dart
//
// 📌 CheckEmailBeforeSignUpUseCase - Email kontrol işlemi
// Clean Architecture'da Use Case, tek bir iş mantığını temsil eder.
// Repository'yi çağırır ve sonucu döner.

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/entities/email_check_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/auth_repository.dart';

/// Email kontrol use case'i
/// 
/// Sign up öncesi email'in kayıtlı olup olmadığını ve hangi provider ile
/// kayıtlı olduğunu kontrol eder.
/// 
/// Kullanım:
/// ```dart
/// final result = await checkEmailUseCase(CheckEmailParams(email: 'test@test.com'));
/// result.fold(
///   (failure) => print(failure.message),
///   (emailCheck) => print('Email exists: ${emailCheck.exists}'),
/// );
/// ```
@injectable
class CheckEmailBeforeSignUpUseCase extends UseCase<EmailCheckEntity, CheckEmailParams> {
  final AuthRepository _repository;

  CheckEmailBeforeSignUpUseCase(this._repository);

  @override
  Future<Either<Failure, EmailCheckEntity>> call(CheckEmailParams params) {
    return _repository.checkEmailMethod(params.email);
  }
}

/// Email kontrol için gerekli parametreler
/// Equatable ile eşitlik kontrolü sağlanır (test için faydalı)
class CheckEmailParams extends Equatable {
  final String email;

  const CheckEmailParams({required this.email});

  @override
  List<Object?> get props => [email];
}

