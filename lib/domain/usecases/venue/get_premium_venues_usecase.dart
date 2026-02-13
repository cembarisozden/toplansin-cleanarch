import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/entities/venue_entity.dart';
import 'package:toplansin_cleanarch/domain/repositories/venue_repository.dart';

@injectable
class GetPremiumVenuesUseCase extends UseCase<List<VenueEntity?>, NoParams> {
  final VenueRepository _repository;

  GetPremiumVenuesUseCase(this._repository);

  @override
  Future<Either<Failure, List<VenueEntity?>>> call(NoParams params) {
    return _repository.getPremiumVenues();
  }
}

