part of widgets;

class MapController with ChangeNotifier {
  _MapState state;

  void setState(_MapState state) {
    this.state = state;
  }

  Future<Symbol> addPin(LatLng coordinates, {bool clearBefore = false}) {
    if (clearBefore) {
      state._mapController.clearSymbols();
    }

    return state._mapController.addSymbol(
      SymbolOptions(
        geometry: coordinates,
        iconImage: state.iconImage,
        iconSize: state.iconSize,
        draggable: true,
      ),
    );
  }

  Future<List<Symbol>> addPins(List<Pin> pins) {
    final symbols = pins.map((pin) {
      return SymbolOptions(
        geometry: LatLng(pin.latitude, pin.longitude),
        iconImage: state.iconImage,
        iconSize: state.iconSize,
        draggable: false,
      );
    }).toList();

    return state._mapController.addSymbols(symbols);
  }

  Future<void> removePin(Symbol symbol) {
    return state._mapController.removeSymbol(symbol);
  }

  Future<bool> moveCamera(CameraUpdate update) {
    return state._mapController.moveCamera(update);
  }

  Future<bool> moveCameraToPosition(LatLng position, {double zoom}) {
    return moveCamera(
      CameraUpdate.newLatLngZoom(
        position,
        zoom ?? 13,
      ),
    );
  }

  Future<bool> moveCameraToCountry(Country country) {
    final cameraUpdate = GeoUtils.calculateLatLngBounds(
      state.context,
      country,
    ).cameraUpdate;

    return moveCamera(cameraUpdate);
  }

  Future<bool> animateCamera(CameraUpdate update) {
    return state._mapController.animateCamera(update);
  }

  Future<void> animateCameraToCountry(Country country) {
    final cameraUpdate = GeoUtils.calculateLatLngBounds(
      state.context,
      country,
    ).cameraUpdate;

    return animateCamera(cameraUpdate);
  }

  Future<void> animateCameraToPin(
    Pin pin, {
    double defaultZoom = 8,
    double overrideZoom,
  }) {
    return animateCamera(
      CameraUpdate.newLatLngZoom(
          pin.toLatLng(),
          overrideZoom != null && overrideZoom < defaultZoom
              ? overrideZoom
              : defaultZoom),
    );
  }

  Future<void> animateCameraToCoordinates(LatLng latLng, {double zoom = 8}) {
    return animateCamera(CameraUpdate.newLatLngZoom(latLng, zoom));
  }

  Future<void> setUnlockedCountries(List<String> countries) {
    if (countries.isNotEmpty) {
      final safeList = countries.toSet().toList();

      return state._mapController.setFilter(
        'country-boundaries',
        [
          "match",
          ["get", "iso_3166_1"],
          safeList,
          true,
          false
        ],
      );
    }

    return null;
  }
}
