import 'package:bucket_map/models/country.dart';
import 'package:flutter/material.dart';

@immutable
class Journey {
  const Journey({
    String id,
    this.userId,
    this.title,
    this.country,
    this.pins,
  }) : this.id = id;

  final String id;
  final String userId;
  final String title;
  final Country country;
  final List<dynamic> pins;

  Journey copyWith({
    String id,
    String userId,
    String title,
    Country country,
    List<dynamic> pins,
  }) {
    return Journey(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      country: country ?? this.country,
      pins: pins ?? this.pins,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Journey && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ title.hashCode ^ country.hashCode ^ pins.hashCode;

  @override
  String toString() {
    return 'Journey { id: $id, userId: $userId, title: $title, country: $country pins: $pins }';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "country": country,
      "pins": pins,
    };
  }

  static Journey fromJson(Map<String, Object> json) {
    return Journey(
      id: json["id"] as String,
      userId: json["userId"] as String,
      title: json["title"] as String,
      country: json["country"] as Country,
      pins: json["pins"] as List<String>,
    );
  }
}
