import 'package:bucket_map/models/models.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CalculatedLatLngBounds {
  CalculatedLatLngBounds({this.bounds, this.cameraUpdate});

  final LatLngBounds bounds;
  final CameraUpdate cameraUpdate;
}

class GeoUtils {
  static CalculatedLatLngBounds calculateLatLngBounds(
    BuildContext context,
    Country country,
  ) {
    if (country.southwest.longitude > 0 && country.northeast.longitude < 0) {
      double lngOverflow = 180 + country.northeast.longitude;
      double lngDifference = 180 + lngOverflow - country.southwest.longitude;
      double rightPadding =
          lngOverflow / lngDifference * MediaQuery.of(context).size.width;
      LatLng modifiedNe = LatLng(country.northeast.latitude, 179.99);

      final bounds = LatLngBounds(
        southwest: country.southwest,
        northeast: modifiedNe,
      );
      final cameraUpdate = CameraUpdate.newLatLngBounds(
        bounds,
        right: rightPadding,
      );

      return CalculatedLatLngBounds(bounds: bounds, cameraUpdate: cameraUpdate);
    }

    final bounds = LatLngBounds(
      southwest: country.southwest,
      northeast: country.northeast,
    );
    final cameraUpdate = CameraUpdate.newLatLngBounds(bounds);

    return CalculatedLatLngBounds(bounds: bounds, cameraUpdate: cameraUpdate);
  }
}
