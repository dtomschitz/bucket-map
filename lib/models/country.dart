import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';


class Country extends Equatable {
  final String name;
  final String code;
  final LatLng latLng;
  final LatLng southwest;
  final LatLng northeast;

  const Country({
    @required this.name,
    @required this.code,
    this.latLng,
    this.southwest,
    this.northeast
  });

    factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      latLng: LatLng(double.parse(json['latitude']), double.parse(json['longitude'])),
      southwest: LatLng(double.parse(json['sw_lat']), double.parse(json['sw_lng'])),
      northeast: LatLng(double.parse(json['ne_lat']), double.parse(json['ne_lng']))
    );
  }

  @override
  List<Object> get props => [name, code];

  @override
  String toString() => 'Country { name: $name code: $code }';
}
