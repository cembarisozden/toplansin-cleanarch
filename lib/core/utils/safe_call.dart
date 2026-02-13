// core/utils/safe_call.dart
import 'package:dartz/dartz.dart';
import 'package:toplansin_cleanarch/core/errors/exceptions.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';

/// Repository metodları için güvenli çağrı helper'ı
/// Exception'ları otomatik olarak Failure'a dönüştürür
Future<Either<Failure, T>> safeCall<T>(
  Future<T> Function() action,
  AppLogger logger,
  String tag,
) async {
  try {
    return Right(await action());
  } on AuthException catch (e) {
    logger.warning('Auth error: ${e.message}', tag: tag);
    return Left(AuthFailure(message: e.message, code: e.code));
  } on ServerException catch (e) {
    logger.warning('Server error: ${e.message}', tag: tag);
    return Left(ServerFailure(message: e.message, code: e.code));
  } on NotFoundException catch (e) {
    logger.warning('Not found: ${e.message}', tag: tag);
    return Left(NotFoundFailure(message: e.message));
  } on NetworkException catch (e) {
    logger.warning('Network error: ${e.message}', tag: tag);
    return Left(NetworkFailure(message: e.message, code: e.code));
  } on TimeoutException catch (e) {
    logger.warning('Timeout: ${e.message}', tag: tag);
    return Left(TimeoutFailure(message: e.message));
  } on StorageException catch (e) {
    logger.warning('Storage error: ${e.message}', tag: tag);
    return Left(StorageFailure(message: e.message));
  } on CacheException catch (e) {
    logger.warning('Cache error: ${e.message}', tag: tag);
    return Left(CacheFailure(message: e.message, code: e.code));
  } on PermissionException catch (e) {
    logger.warning('Permission error: ${e.message}', tag: tag);
    return Left(PermissionFailure(message: e.message));
  } on ValidationException catch (e) {
    logger.warning('Validation error: ${e.message}', tag: tag);
    return Left(ValidationFailure(message: e.message, field: e.field));
  } on FormatException catch (e) {
    logger.warning('Format error: ${e.message}', tag: tag);
    return Left(FormatFailure(message: e.message));
  } catch (e, stackTrace) {
    logger.error('Unknown error: $e', tag: tag, error: e, stackTrace: stackTrace);
    return Left(UnknownFailure(message: e.toString()));
  }
}