import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NumberTrivia extends Equatable {
  final int? number;
  final String? text;
  const NumberTrivia({
    @required this.number,
    @required this.text,
  }) : super();

  @override
  // TODO: implement props
  List<Object> get props => [text!, number!];
}
