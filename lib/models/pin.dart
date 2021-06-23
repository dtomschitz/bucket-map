import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

class Pin extends Equatable {
  const Pin({
    @required this.id,
    @required this.name,
    @required this.lat,
    @required this.lng,
    this.description,
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
  final String description;

  @override
  List<Object> get props => [id, name, lat, lng, description];

  Pin copyWith({
    String id,
    String name,
    double lat,
    double lng,
    String description,
  }) {
    return Pin(
      id: id ?? this.id,
      name: name ?? this.name,
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
      name.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      description.hashCode;

  @override
  String toString() {
    return 'Profile { id: $id, name: $name, lat: $lat, lon: $lng, description: $description}';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "lat": lat,
      "lng": lng,
      "description": description
    };
  }

  static Pin fromJson(Map<String, Object> json) {
    return Pin(
      id: json["id"] as String,
      name: json["name"] as String,
      lat: json["lat"] as double,
      lng: json["lng"] as double,
      description: json["description"] as String,
    );
  }
}
