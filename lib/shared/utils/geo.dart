part of shared.utils;

class GeoUtils {
  static final String geoNamesApi = "http://api.geonames.org";

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

  static Future<String> getCountryCode(LatLng coordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );

    return placemarks.isNotEmpty ? placemarks.first.isoCountryCode : null;
  }

  static Future<GeoCountry> fetchCountry(LatLng latLng) async {
    final latitude = latLng.latitude;
    final longitude = latLng.longitude;

    final url = "https://geocode.xyz/$latitude,$longitude?json=1";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) return null;

    return GeoCountry.fromJson(jsonDecode(response.body));
  }
}
