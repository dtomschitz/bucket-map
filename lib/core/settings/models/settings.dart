import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  final ThemeMode themeMode;

  const Settings({
    this.themeMode = ThemeMode.system,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      themeMode: ThemeMode.values[json['themeMode']],
    );
  }

  Settings copyWith({ThemeMode themeMode, String name, Color color}) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Settings merge(Settings other) {
    if (other == null) return this;

    return copyWith(themeMode: other.themeMode);
  }

  @override
  List<Object> get props => [themeMode];

  @override
  String toString() => 'Settings { themeMode: $themeMode }';

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
    };
  }
}
