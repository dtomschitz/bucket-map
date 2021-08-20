part of shared.models;

class Pin extends Equatable {
  const Pin({
    this.id,
    this.userId,
    this.country,
    this.name,
    this.latitude,
    this.longitude,
    this.dateTime,
  });

  final String id;
  final String userId;
  final String name;
  final String country;

  final double latitude;
  final double longitude;

  final DateTime dateTime;

  static Pin create({
    String name,
    String country,
    double latitude,
    double longitude,
    DateTime dateTime,
  }) {
    return Pin(
      name: name,
      country: country,
      latitude: latitude,
      longitude: longitude,
      dateTime: DateTime.now(),
    );
  }

  static Pin fromJson(String id, Map<String, Object> json) {
    return Pin(
      id: id,
      userId: json["userId"] as String,
      name: json["name"] as String,
      country: json["country"] as String,
      latitude: json["latitude"] as double,
      longitude: json["longitude"] as double,
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Pin copyWith({
    String id,
    String userId,
    String name,
    String country,
    double latitude,
    double longitude,
    DateTime dateTime,
  }) {
    return Pin(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  LatLng toLatLng() => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "country": country,
      "latitude": latitude,
      "longitude": longitude,
      "dateTime": dateTime.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pin &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          country == other.country &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      country.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      dateTime.hashCode;

  @override
  List<Object> get props => [
        id,
        userId,
        name,
        country,
        latitude,
        longitude,
        dateTime,
      ];

  @override
  String toString() {
    return 'Pin { id: $id, userId: $userId, name: $name, country: $country latitude: $latitude, longitude: $longitude }';
  }
}
