import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

class Pin extends Equatable {
  const Pin({
    this.id,
    this.userId,
    this.country,
    @required this.name,
    @required this.lat,
    @required this.lng,
    this.description,
  });

  final String id;
  final String userId;
  final String name;
  final String country;
  final double lat;
  final double lng;
  final String description;

  @override
  List<Object> get props => [id, userId, name, country, lat, lng, description];

  Pin copyWith({
    String id,
    String userId,
    String name,
    String country,
    double lat,
    double lng,
    String description,
  }) {
    return Pin(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pin && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      country.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      description.hashCode;

  @override
  String toString() {
    return 'Profile { id: $id, name: $name, country: $country lat: $lat, lon: $lng, description: $description}';
  }

  LatLng toLatLng() => LatLng(lat, lng);

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "country": country,
      "lat": lat,
      "lng": lng,
      "description": description
    };
  }

  static Pin fromJson(String id, Map<String, Object> json) {
    return Pin(
      id: id,
      userId: json["userId"] as String,
      name: json["name"] as String,
      country: json["country"] as String,
      lat: json["lat"] as double,
      lng: json["lng"] as double,
      description: json["description"] as String,
    );
  }
}
