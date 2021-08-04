part of shared.events;

class ShowCreatePinSheet extends Event {
  const ShowCreatePinSheet({this.coordinates});
  final LatLng coordinates;
}
