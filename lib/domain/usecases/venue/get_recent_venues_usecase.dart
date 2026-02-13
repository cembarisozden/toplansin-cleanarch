import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/venue_repository.dart';

@injectable
class GetRecentVenuesUseCase extends UseCase<List<VenueEntity?>, NoParams> {
  final VenueRepository _repository;

  GetRecentVenuesUseCase(this._repository);

  @override
  Future<Either<Failure, List<VenueEntity?>>> call(NoParams params) {
    return _repository.getRecentVenues();
  }
}