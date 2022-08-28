import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/errors/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required GetConcreteNumberTrivia concrete,
      required GetRandomNumberTrivia random,
      required this.inputConverter})
      : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToSignedInteger(event.numberString!);
        await inputEither.fold(
          (failure) async {
            emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (integer) async {
            emit(Loading());
            final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: integer));
            _eitherLoadedOrErrorState(failureOrTrivia, emit);
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        _eitherLoadedOrErrorState(failureOrTrivia, emit);
      }
    });
  }

  void _eitherLoadedOrErrorState(Either<Failures, NumberTrivia> either,
      Emitter<NumberTriviaState> emit) async {
    either.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failures failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
// class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
//   final GetConcreteNumberTrivia getConcreteNumberTrivia;
//   final GetRandomNumberTrivia getRandomNumberTrivia;
//   final InputConverter inputConverter;
//
//   NumberTriviaBloc({
//     required GetConcreteNumberTrivia concrete,
//     required GetRandomNumberTrivia random,
//     required this.inputConverter,
//   })  : assert(concrete != null),
//         assert(random != null),
//         assert(inputConverter != null),
//         getConcreteNumberTrivia = concrete,
//         getRandomNumberTrivia = random,
//         super(Empty());
//
//   @override
//   NumberTriviaState get initialState => Empty();
//
//   @override
//   Stream<NumberTriviaState> mapEventToState(
//     NumberTriviaEvent event,
//   ) async* {
//     if (event is GetTriviaForConcreteNumber) {
//       final inputEither =
//           inputConverter.stringToSignedInteger(event.numberString!);
//
//       yield* inputEither.fold(
//         (failure) async* {
//           yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
//         },
//         (integer) async* {
//           yield Loading();
//           final failureOrTrivia =
//               await getConcreteNumberTrivia(Params(number: integer));
//           yield* _eitherLoadedOrErrorState(failureOrTrivia);
//         },
//       );
//     } else if (event is GetTriviaForRandomNumber) {
//       yield Loading();
//       final failureOrTrivia = await getRandomNumberTrivia(NoParams());
//       yield* _eitherLoadedOrErrorState(failureOrTrivia);
//     }
//   }
//
//   Stream<NumberTriviaState> _eitherLoadedOrErrorState(
//     Either<Failures, NumberTrivia> failureOrTrivia,
//   ) async* {
//     yield failureOrTrivia.fold(
//       (failure) => Error(message: _mapFailureToMessage(failure)),
//       (trivia) => Loaded(trivia: trivia),
//     );
//   }
//
//   String _mapFailureToMessage(Failures failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return SERVER_FAILURE_MESSAGE;
//       case CacheFailure:
//         return CACHE_FAILURE_MESSAGE;
//       default:
//         return 'Unexpected error';
//     }
//   }
// }
