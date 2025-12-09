import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:toplansin_cleanarch/core/errors/failures.dart';

/// Base UseCase sınıfı
/// T: Dönen değer tipi
/// Params: Parametre tipi
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Parametre gerektirmeyen use case'ler için
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

