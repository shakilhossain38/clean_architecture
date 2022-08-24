import 'package:clean_architecture/core/errors/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/features/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/domain/repositories/number_trivia_repositories.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  late final NumberTriviaRepository repository;
  @override
  Future<Either<Failures, NumberTrivia>> call(NoParams params) async {
    // TODO: implement call
    return await repository.getRandomNumberTrivia();
  }
}
