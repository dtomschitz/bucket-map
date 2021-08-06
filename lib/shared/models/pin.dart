part of shared.models;

class Pin extends Equatable {
  const Pin({
    this.id,
    this.userId,
    this.country,
    @required this.name,
    @required this.latitude,
    @required this.longitude,
    this.description,
  });

  final String id;
  final String userId;
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String description;

  @override
  List<Object> get props => [
        id,
        userId,
        name,
        country,
        latitude,
        longitude,
        description,
      ];

  Pin copyWith({
    String id,
    String userId,
    String name,
    String country,
    double latitude,
    double longitude,
    String description,
  }) {
    return Pin(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
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
      latitude.hashCode ^
      longitude.hashCode ^
      description.hashCode;

  @override
  String toString() {
    return 'Pin { id: $id, userId: $userId, name: $name, country: $country latitude: $latitude, longitude: $longitude, description: $description}';
  }

  LatLng toLatLng() => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "country": country,
      "latitude": latitude,
      "longitude": longitude,
      "description": description
    };
  }

  static Pin fromJson(String id, Map<String, Object> json) {
    return Pin(
      id: id,
      userId: json["userId"] as String,
      name: json["name"] as String,
      country: json["country"] as String,
      latitude: json["latitude"] as double,
      longitude: json["longitude"] as double,
      description: json["description"] as String,
    );
  }
}
