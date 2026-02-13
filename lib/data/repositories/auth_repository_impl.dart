// data/repositories/auth_repository_impl.dart
//
// 📌 AuthRepositoryImpl - Auth Repository implementasyonu
//
// Data Layer'da bulunur.
// DataSource'dan gelen Exception'ları Failure'a dönüştürür.
// Domain Layer'a Either<Failure, T> döndürür.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/exceptions.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/services/interfaces/crashlytics_service.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/data/datasources/remote/auth_remote_datasource.dart';
import 'package:toplansin_cleanarch/domain/entities/email_check_entity.dart';
import 'package:toplansin_cleanarch/domain/entities/user_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AppLogger _logger;
  final ICrashlyticsService _crashlytics;

  AuthRepositoryImpl(this._remoteDataSource, this._logger, this._crashlytics);

  // ─────────────────────────────────────────────────────────────────────────
  // AUTH METHODS
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, EmailCheckEntity>> checkEmailMethod(
    String email,
  ) async {
    _logger.debug('Check email method: $email', tag: 'AuthRepo');
    try {
      final result = await _remoteDataSource.checkEmailMethod(email);
      return Right(result);
    } on AuthException catch (e) {
      _logger.warning(
        'Check email method failed: ${e.message}',
        tag: 'AuthRepo',
      );
      return Left(_mapAuthExceptionToFailure(e));
    } on ServerException catch (e) {
      _logger.error(
        'Check email method server error: ${e.message}',
        tag: 'AuthRepo',
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      _logger.error(
        'Check email method network error: ${e.message}',
        tag: 'AuthRepo',
      );
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      _logger.error(
        'Check email method unknown error: $e',
        tag: 'AuthRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _logger.debug('Sign up attempt: $email', tag: 'AuthRepo');
    try {
      final user = await _remoteDataSource.signUp(email, password, name);

      await _remoteDataSource.saveUserToFirestore(user);

      await _crashlytics.setUserIdentifier(user.id);
      _logger.info('Sign up successful: ${user.id}', tag: 'AuthRepo');
      return Right(user);
    } on AuthException catch (e) {
      _logger.warning('Sign up failed: ${e.message}', tag: 'AuthRepo');
      return Left(_mapAuthExceptionToFailure(e));
    } on ServerException catch (e) {
      _logger.error('Sign up server error: ${e.message}', tag: 'AuthRepo');
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      _logger.error('Sign up network error: ${e.message}', tag: 'AuthRepo');
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      _logger.error(
        'Sign up unknown error: $e',
        tag: 'AuthRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  ) async {
    _logger.debug('Sign in attempt: $email', tag: 'AuthRepo');
    try {
      final user = await _remoteDataSource.signIn(email, password);
      final userDocument = await _remoteDataSource.getUserDocument(user.id);
      if (userDocument == null) {
        await _remoteDataSource.saveUserToFirestore(user);
      }

      await _crashlytics.setUserIdentifier(user.id);
      _logger.info('Sign in successful: ${user.id}', tag: 'AuthRepo');
      return Right(userDocument ?? user);
    } on AuthException catch (e) {
      _logger.warning('Sign in failed: ${e.message}', tag: 'AuthRepo');
      return Left(_mapAuthExceptionToFailure(e));
    } on ServerException catch (e) {
      _logger.error('Sign in server error: ${e.message}', tag: 'AuthRepo');
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      _logger.error('Sign in network error: ${e.message}', tag: 'AuthRepo');
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      _logger.error(
        'Sign in unknown error: $e',
        tag: 'AuthRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    _logger.debug('Google sign in attempt', tag: 'AuthRepo');
    try {
      final user = await _remoteDataSource.signInWithGoogle();

      // Kullanıcı iptal etti
      if (user == null) {
        _logger.warning('Google sign in cancelled', tag: 'AuthRepo');
        return Left(
          AuthFailure(
            message: 'Google ile giriş iptal edildi',
            errorType: AuthErrorType.cancelled,
          ),
        );
      }
      final userDocument = await _remoteDataSource.getUserDocument(user.id);

      // Kullanıcıyı Firestore'a kaydet
      if (userDocument == null) {
        await _remoteDataSource.saveUserToFirestore(user);
      }

      await _crashlytics.setUserIdentifier(user.id);
      _logger.info('Google sign in successful: ${user.id}', tag: 'AuthRepo');
      return Right(userDocument ?? user);
    } on AuthException catch (e) {
      _logger.warning('Google sign in failed: ${e.message}', tag: 'AuthRepo');
      return Left(_mapAuthExceptionToFailure(e));
    } on ServerException catch (e) {
      _logger.error(
        'Google sign in server error: ${e.message}',
        tag: 'AuthRepo',
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      _logger.error(
        'Google sign in network error: ${e.message}',
        tag: 'AuthRepo',
      );
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      _logger.error(
        'Google sign in unknown error: $e',
        tag: 'AuthRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    _logger.debug('Apple sign in attempt', tag: 'AuthRepo');
    try {
      final user = await _remoteDataSource.signInWithApple();

      // Kullanıcı iptal etti
      if (user == null) {
        _logger.warning('Apple sign in cancelled', tag: 'AuthRepo');
        return Left(
          AuthFailure(
            message: 'Apple ile giriş iptal edildi',
            errorType: AuthErrorType.cancelled,
          ),
        );
      }
      final userDocument = await _remoteDataSource.getUserDocument(user.id);
      if (userDocument == null) {
        await _remoteDataSource.saveUserToFirestore(user);
      }
      await _crashlytics.setUserIdentifier(user.id);
      _logger.info('Apple sign in successful: ${user.id}', tag: 'AuthRepo');
      return Right(userDocument ?? user);
    } on AuthException catch (e) {
      _logger.warning('Apple sign in failed: ${e.message}', tag: 'AuthRepo');
      return Left(_mapAuthExceptionToFailure(e));
    } on ServerException catch (e) {
      _logger.error(
        'Apple sign in server error: ${e.message}',
        tag: 'AuthRepo',
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      _logger.error(
        'Apple sign in network error: ${e.message}',
        tag: 'AuthRepo',
      );
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      _logger.error(
        'Apple sign in unknown error: $e',
        tag: 'AuthRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    _logger.debug('Sign out attempt', tag: 'AuthRepo');
    try {
      await _remoteDataSource.signOut();
      await _crashlytics.clearUserIdentifier();
      _logger.info('Sign out successful', tag: 'AuthRepo');
      return const Right(null);
    } on AuthException catch (e) {
      _logger.warning('Sign out failed: ${e.message}', tag: 'AuthRepo');
      return Left(_mapAuthExceptionToFailure(e));
    } on ServerException catch (e) {
      _logger.error('Sign out server error: ${e.message}', tag: 'AuthRepo');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      _logger.error(
        'Sign out unknown error: $e',
        tag: 'AuthRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // EXCEPTION → FAILURE MAPPING
  // ─────────────────────────────────────────────────────────────────────────

  /// AuthException → AuthFailure dönüşümü
  /// Firebase error code'ları generic AuthErrorType'a map'lenir
  AuthFailure _mapAuthExceptionToFailure(AuthException e) {
    final errorType = switch (e.errorCode) {
      'user-not-found' => AuthErrorType.emailNotFound,
      'email-already-in-use' => AuthErrorType.emailInUse,
      'invalid-email' => AuthErrorType.invalidEmail,
      'wrong-password' || 'invalid-credential' => AuthErrorType.wrongPassword,
      'weak-password' => AuthErrorType.weakPassword,
      'user-disabled' => AuthErrorType.userDisabled,
      'too-many-requests' => AuthErrorType.tooManyRequests,
      'network-request-failed' => AuthErrorType.networkError,
      'account-exists-with-different-credential' =>
        AuthErrorType.accountExistsWithDifferentCredential,
      'cancelled' => AuthErrorType.cancelled,
      _ => AuthErrorType.unknown,
    };

    return AuthFailure(message: e.message, code: e.code, errorType: errorType);
  }
}
