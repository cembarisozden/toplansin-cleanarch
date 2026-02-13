import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/venue_repository.dart';

@injectable
class GetSavedVenuesUseCase extends UseCase<List<VenueEntity?>, String> {
  final VenueRepository _repository;

  GetSavedVenuesUseCase(this._repository);

  @override
  Future<Either<Failure, List<VenueEntity?>>> call(String userId) {
    return _repository.getSavedVenues(userId);
  }
}