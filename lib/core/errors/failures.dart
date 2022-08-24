import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failures {}

class CacheFailure extends Failures {}
