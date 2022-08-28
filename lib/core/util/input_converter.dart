import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

class InputConverter {
  Either<Failures, int> stringToSignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(int.parse(str));
    } on FormatException {
      return Left(InvalidInputCapture());
    }
  }
}

class InvalidInputCapture extends Failures {}
