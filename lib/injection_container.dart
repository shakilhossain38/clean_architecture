import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/data/datasources/number_trivia_local_data_souce.dart';
import 'package:clean_architecture/features/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/data/repositories/number_trivia_repositry_implementation.dart';
import 'package:clean_architecture/features/domain/repositories/number_trivia_repositories.dart';
import 'package:clean_architecture/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  ///bloc
  sl.registerFactory(() =>
      NumberTriviaBloc(inputConverter: sl(), random: sl(), concrete: sl()));

  ///use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  ///repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          networkInfo: sl(), remoteDataSource: sl(), localDataSource: sl()));

  ///data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImp(sharedPreferences: sl()));

  ///core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(sl()));

  ///external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
