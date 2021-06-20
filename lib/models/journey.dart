import 'package:flutter/material.dart';

@immutable
class Journey {
  const Journey({
    String id,
    this.userId,
    this.title,
    this.pins,
  }) : this.id = id;

  final String id;
  final String userId;
  final String title;
  final List<dynamic> pins;

  Journey copyWith({
    String id,
    String userId,
    String title,
  }) {
    return Journey(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      pins: pins ?? this.pins,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Journey && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ title.hashCode ^ pins.hashCode;

  @override
  String toString() {
    return 'Journey { id: $id, userId: $userId, title: $title, pins: $pins }';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "pins": pins,
    };
  }

  static Journey fromJson(Map<String, Object> json) {
    return Journey(
      id: json["id"] as String,
      userId: json["userId"] as String,
      title: json["title"] as String,
      pins: json["pins"] as List<String>,
    );
  }
}
