import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class Country extends Equatable {
  const Country({
    @required this.name,
    @required this.code,
    this.latLng,
    this.southwest,
    this.northeast,
    bool unlocked,
  }) : this.unlocked = unlocked ?? false;

  final String name;
  final String code;
  final LatLng latLng;
  final LatLng southwest;
  final LatLng northeast;
  final bool unlocked;

  Country copyWith({
    String name,
    String code,
    LatLng latLng,
    LatLng southwest,
    LatLng northeast,
    bool unlocked,
  }) {
    return Country(
      name: name ?? this.name,
      code: code ?? this.code,
      latLng: latLng ?? this.latLng,
      southwest: southwest ?? this.southwest,
      northeast: northeast ?? this.northeast,
      unlocked: unlocked ?? this.unlocked,
    );
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      latLng: LatLng(
        double.parse(json['latitude']),
        double.parse(json['longitude']),
      ),
      southwest: LatLng(
        double.parse(json['sw_lat']),
        double.parse(json['sw_lng']),
      ),
      northeast: LatLng(
        double.parse(json['ne_lat']),
        double.parse(json['ne_lng']),
      ),
      //unlocked: false,
      unlocked: new Random().nextDouble() <= .5,
    );
  }

  @override
  List<Object> get props =>
      [name, code, latLng, southwest, northeast, unlocked];

  @override
  String toString() => 'Country { name: $name code: $code, unlocked: $unlocked }';
}
