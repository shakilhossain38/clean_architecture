import 'package:clean_architecture/core/errors/failures.dart';
import 'package:clean_architecture/features/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
}
