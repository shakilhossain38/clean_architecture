import 'package:clean_architecture/core/errors/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/features/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/domain/repositories/number_trivia_repositories.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, int> {
  late final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failures, NumberTrivia>> call(int number) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}

class Params extends Equatable {
  final int? number;
  const Params({required this.number});

  @override
  // TODO: implement props
  List<Object?> get props => [number];
}
