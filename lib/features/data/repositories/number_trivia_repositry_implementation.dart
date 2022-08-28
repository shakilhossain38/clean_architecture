import 'package:clean_architecture/core/errors/exceptions.dart';
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:clean_architecture/features/data/datasources/number_trivia_local_data_souce.dart';
import 'package:clean_architecture/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/data/model/number_trivia_model.dart';
import 'package:clean_architecture/features/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/domain/repositories/number_trivia_repositories.dart';
import 'package:dartz/dartz.dart';

import '../../../core/network/network_info.dart';

typedef Future<NumberTriviaModel> _concreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource? localDataSource;
  final NumberTriviaRemoteDataSource? remoteDataSource;
  final NetworkInfo? networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.networkInfo,
      required this.remoteDataSource,
      required this.localDataSource});

  @override
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    // TODO: implement getConcreteNumberTrivia

    return await _getTrivia(() {
      return remoteDataSource!.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource!.getRandomNumberTrivia();
    });
  }

  Future<Either<Failures, NumberTriviaModel>> _getTrivia(
      _concreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo!.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource?.cachedNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerExceptions {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource?.getLastNumberTrivia();
        return Right(localTrivia!);
      } on CacheExceptions {
        return Left(CacheFailure());
      }
    }
  }
}
