import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Pin extends Equatable {
  final String name;
  final DateTime date;
  final Symbol symbol;

  const Pin({
    @required this.name,
    @required this.date,
    @required this.symbol,
  });

  @override
  List<Object> get props => [name, date, symbol];

  @override
  String toString() => 'Pin { name: $name date: $date code: $symbol }';
}
