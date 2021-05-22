import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';


class Country extends Equatable {
  final String name;
  final String code;
    final LatLng latLng;

  const Country({
    @required this.name,
    @required this.code,
    this.latLng
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      latLng: LatLng(json['latitude'], json['longitude'])
    );
  }

  @override
  List<Object> get props => [name, code];

  @override
  String toString() => 'Country { name: $name code: $code }';
}
