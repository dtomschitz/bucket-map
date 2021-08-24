part of shared.models;

class CalculatedLatLngBounds {
  CalculatedLatLngBounds({this.bounds, this.cameraUpdate});

  final LatLngBounds bounds;
  final CameraUpdate cameraUpdate;
}
