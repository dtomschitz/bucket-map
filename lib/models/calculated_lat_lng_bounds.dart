import 'package:mapbox_gl/mapbox_gl.dart';

class CalculatedLatLngBounds {
  CalculatedLatLngBounds({this.bounds, this.cameraUpdate});

  final LatLngBounds bounds;
  final CameraUpdate cameraUpdate;
}
