import 'package:dartz/dartz.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';

abstract class VenueRepository {
  Future<Either<Failure, List<VenueEntity?>>> getPremiumVenues();
  Future<Either<Failure, List<VenueEntity?>>> getRecentVenues();
  Future<Either<Failure, List<VenueEntity?>>> getSavedVenues(String userId);
  Future<Either<Failure, VenueEntity?>> getVenueById(String venueId);
  Future<Either<Failure, void>> toggleSaveVenue(String venueId, String userId);
}