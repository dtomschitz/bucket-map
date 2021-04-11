import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geojson/geojson.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Country extends Equatable {
  final String name;
  final String code;
  final List<LatLng> points;
  //final List<LatLng> points;

  const Country({
    @required this.name,
    @required this.code,
    @required this.points,
  });

  factory Country.fromGeoJsonFeature(GeoJsonFeature<dynamic> feature) {
    List<LatLng> points = [];

    var transformGeoPoint = (geoPoint) => LatLng(
          geoPoint.latitude,
          geoPoint.longitude,
        );

    if (feature.geometry is GeoJsonPolygon) {
      points = (feature.geometry as GeoJsonPolygon)
          .geoSeries
          .map((geoSerie) => geoSerie.geoPoints.map(transformGeoPoint).toList())
          .expand((point) => point)
          .toList();
    } else if (feature.geometry is GeoJsonMultiPolygon) {
      /*points = (feature.geometry as GeoJsonMultiPolygon)
          .polygons
          .map((polygon) => polygon.geoSeries
              .map((geoSerie) =>
                  geoSerie.geoPoints.map(transformGeoPoint).toList())
              .toList())
          .expand((element) => element)
          .toList();*/
    }

    return Country(
      name: feature.properties['ADMIN'],
      code: feature.properties['ISO_A3'],
      points: points,
    );
  }

  @override
  List<Object> get props => [name, code];

  @override
  String toString() => 'Country { name: $name code: $code }';
}

/*final List<Country> countries = <Country>[
  Country(name: 'Deutschland', code: 'de'),
  Country(name: 'Frankreich', code: 'fr'),
  Country(name: 'United States', code: 'us'),
  Country(name: 'Italien', code: 'it'),
  Country(name: 'Afghanistan', code: 'af'),
  Country(name: 'Antarctica', code: 'aq'),
  Country(name: 'Bhutan', code: 'bt'),
  Country(name: 'Brazil', code: 'br'),
  Country(name: 'Chile', code: 'cl'),
  Country(name: 'Cuba', code: 'cu'),
  Country(name: 'Croatia', code: 'hr'),
  Country(
    name: 'Denmark',
    code: 'dk',
  ),
  Country(name: 'Finland', code: 'fi'),
  Country(name: 'Ghana', code: 'gh'),
  Country(
    name: 'Heard Island and McDonald Islands',
    code: 'hm',
  ),
  Country(
    name: 'Mexico',
    code: 'mx',
  ),
  Country(
    name: 'Pakistan',
    code: 'pk',
  ),
  Country(
    name: 'United Kingdom',
    code: 'gb',
  ),
  Country(
    name: 'Vatican City (Holy See)',
    code: 'va',
  ),
];
*/
