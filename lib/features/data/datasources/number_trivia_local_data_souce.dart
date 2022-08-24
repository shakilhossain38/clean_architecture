import 'package:clean_architecture/features/data/model/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cachedNumberTrivia(NumberTriviaModel triviaToCache);
}
