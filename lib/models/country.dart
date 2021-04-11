import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Country extends Equatable {
  final String name;
  final String code;

  const Country({
    @required this.name,
    @required this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
    );
  }

  @override
  List<Object> get props => [name, code];

  @override
  String toString() => 'Country { name: $name code: $code }';
}