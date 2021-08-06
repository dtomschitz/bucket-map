part of widgets;

class CountriesMapController with ChangeNotifier {
  _CountriesMapState state;

  void setState(_CountriesMapState state) {
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

  Future<void> animateCameraToPin(Pin pin, {double zoom = 8}) {
    return animateCamera(CameraUpdate.newLatLngZoom(pin.toLatLng(), zoom));
  }

  Future<void> animateCameraToCoordinates(
    LatLng latLng, {
    double zoom = 8,
    bool minZoom = false,
  }) {
    /*if (minZoom) {
      var currentZoom = state._cameraPosition.zoom;
      return animateCamera(CameraUpdate.newLatLngZoom(
        latLng,
        currentZoom > zoom ? currentZoom : zoom,
      ));
    }*/

    return animateCamera(CameraUpdate.newLatLngZoom(latLng, zoom));
  }

  Future<void> setUnlockedCountries(List<String> countries) {
    if (countries.isNotEmpty) {
      return state._mapController.setFilter(
        'country-boundaries',
        [
          "match",
          ["get", "iso_3166_1"],
          countries,
          true,
          false
        ],
      );
    }

    return null;
  }
}
