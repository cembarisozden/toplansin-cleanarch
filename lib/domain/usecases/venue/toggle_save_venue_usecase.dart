import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';
import 'package:toplansin_cleanarch/core/usecases/usecase.dart';
import 'package:toplansin_cleanarch/domain/repositories/venue_repository.dart';

@injectable
class ToggleSaveVenueUseCase extends UseCase<void, (String venueId, String userId)> {
  final VenueRepository _repository;
  ToggleSaveVenueUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(params) {
    return _repository.toggleSaveVenue(params.$1, params.$2);
  }
}