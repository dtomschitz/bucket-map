import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Journey {
  const Journey(this.title, {String id}) : this.id = id;

  final String id;
  final String title;

  Journey copyWith({
    String id,
    String title,
  }) {
    return Journey(
      title ?? this.title,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Journey && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Journey { id: $id, title: $title }';
  }

  JourneyEntity toEntity() {
    return JourneyEntity(
      title,
      id,
    );
  }

  static Journey fromEntity(JourneyEntity entity) {
    return Journey(
      entity.title,
      id: entity.id,
    );
  }
}

class JourneyEntity extends Equatable {
  const JourneyEntity(this.id, this.title);

  final String id;
  final String title;

  Map<String, Object> toJson() {
    return {
      "id": id,
    };
  }

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'TodoEntity { id: $id, title: $title }';
  }

  static JourneyEntity fromJson(Map<String, Object> json) {
    return JourneyEntity(
      json["id"] as String,
      json["title"] as String,
    );
  }

  static JourneyEntity fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data();
    return JourneyEntity(
      data['id'],
      data['title'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "title": title,
    };
  }
}
