import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

class Pin extends Equatable {
  final int id;
  final String name;
  final Symbol symbol;
  final String description;

  const Pin({
    @required this.id,
    @required this.name,
    @required this.symbol,
    this.description,
  });

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'Country { name: $name }';
}
