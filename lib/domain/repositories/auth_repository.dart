// domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/domain/entities/email_check_entity.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';

abstract class AuthRepository {
  // Email/şifre ile kayıt (İLK KAYIT - name gerekli)
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,  // ← EKLENECEK
  });
  
  // Email/şifre ile giriş (MEVCUT KULLANICI)
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  );
  
  // Google ile giriş/kayıt
  Future<Either<Failure, UserEntity>> signInWithGoogle();  // ← Either olmalı
  
  // Apple ile giriş/kayıt
  Future<Either<Failure, UserEntity>> signInWithApple();  // ← Either olmalı
  
  Future<Either<Failure, void>> signOut();

Future<Either<Failure, EmailCheckEntity>> checkEmailMethod(String email);
}