part of shared.models;

class GeoCountry {
  GeoCountry({
    this.code,
    this.name,
    this.languages,
    this.distance,
  });

  final String code;
  final String name;
  final String languages;
  final String distance;

  factory GeoCountry.fromJson(Map<String, dynamic> json) {
    return GeoCountry(
      code: json['code'],
      name: json['name'],
      languages: json['languages'],
      distance: json['distance'],
    );
  }
}
