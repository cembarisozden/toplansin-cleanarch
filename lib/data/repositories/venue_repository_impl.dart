import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/utils/logger.dart';
import 'package:toplansin_cleanarch/core/utils/safe_call.dart';
import 'package:toplansin_cleanarch/data/datasources/remote/venue_remote_datasoruce.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/venue_repository.dart';

@LazySingleton(as: VenueRepository)
class VenueRepositoryImpl implements VenueRepository {
  final VenueRemoteDataSource _remoteDataSource;
  final AppLogger _logger;
  VenueRepositoryImpl(this._remoteDataSource, this._logger);

  @override
  Future<Either<Failure, List<VenueEntity?>>> getPremiumVenues() async {
    return safeCall(
      () => _remoteDataSource.getPremiumVenues(),
      _logger,
      'VenueRepo.getPremiumVenues',
    );
  }

  @override
  Future<Either<Failure, List<VenueEntity?>>> getRecentVenues() async {
    return safeCall(
      () => _remoteDataSource.getRecentVenues(),
      _logger,
      'VenueRepo.getRecentVenues',
    );
  }
  @override
  Future<Either<Failure, List<VenueEntity?>>> getSavedVenues(String userId) async {
    return safeCall(
      () => _remoteDataSource.getSavedVenues(userId),
      _logger,
      'VenueRepo.getSavedVenues',
    );
  }
  @override
  Future<Either<Failure, VenueEntity?>> getVenueById(String venueId) async {
    return safeCall(
      () => _remoteDataSource.getVenueById(venueId),
      _logger,
      'VenueRepo.getVenueById',
    );
  }
  @override
  Future<Either<Failure, void>> toggleSaveVenue(String venueId, String userId) async {
    return safeCall(
      () => _remoteDataSource.toggleSaveVenue(venueId, userId),
      _logger,
      'VenueRepo.toggleSaveVenue',
    );
  }
}