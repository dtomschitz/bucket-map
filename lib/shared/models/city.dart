part of shared.models;

class City extends Equatable {
  final String name;
  final LatLng latLng;
  final String country;

  const City({
    @required this.name,
    this.latLng,
    this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      country: json['country'],
      latLng: LatLng(
        double.parse(json['lat']),
        double.parse(json['lng']),
      ),
    );
  }

  @override
  List<Object> get props => [name, country, latLng];

  @override
  String toString() => 'City { name: $name country: $country }';
}
