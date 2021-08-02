part of shared.widgets;

class CountriesMap extends StatefulWidget {
  const CountriesMap({
    Key key,
    this.controller,
    this.onMapCreated,
    this.onStyleLoaded,
    this.onCameraIdle,
    this.onMapClick,
    this.onMapLongClick,
    this.locationPadding,
    this.locationAlignment,
    CameraPosition initialCameraPosition,
    CameraTargetBounds cameraTargetBounds,
    bool tiltGesturesEnabled,
    bool rotateGesturesEnabled,
    bool zoomGesturesEnabled,
    bool scrollGesturesEnabled,
    bool disableUserLocation,
  })  : this.initialCameraPosition = initialCameraPosition ??
            const CameraPosition(target: LatLng(0.0, 0.0)),
        this.cameraTargetBounds =
            cameraTargetBounds ?? CameraTargetBounds.unbounded,
        this.tiltGesturesEnabled = tiltGesturesEnabled ?? false,
        this.rotateGesturesEnabled = rotateGesturesEnabled ?? false,
        this.scrollGesturesEnabled = scrollGesturesEnabled ?? true,
        this.zoomGesturesEnabled = zoomGesturesEnabled ?? true,
        this.disableUserLocation = disableUserLocation ?? false,
        super(key: key);

  final CountriesMapController controller;

  final Function() onMapCreated;
  final Function() onStyleLoaded;

  final Function(CameraPosition cameraPosition) onCameraIdle;

  final Function(Point<double> point, LatLng coordinates) onMapClick;
  final Function(Point<double> point, LatLng coordinates) onMapLongClick;

  final EdgeInsets locationPadding;
  final Alignment locationAlignment;

  final CameraPosition initialCameraPosition;
  final CameraTargetBounds cameraTargetBounds;

  final bool tiltGesturesEnabled;
  final bool rotateGesturesEnabled;
  final bool zoomGesturesEnabled;
  final bool scrollGesturesEnabled;
  final bool disableUserLocation;

  @override
  State createState() => _CountriesMapState(
        controller ?? CountriesMapController(),
      );
}

class _CountriesMapState extends State<CountriesMap>
    with TickerProviderStateMixin {
  _CountriesMapState(this.controller) {
    this.controller.setState(this);
  }

  final CountriesMapController controller;
  final iconImage = "location_pin";
  final iconSize = 0.12;

  MapboxMapController _mapController;
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;

    final ByteData bytes = await rootBundle.load("assets/location_pin.png");
    final Uint8List list = bytes.buffer.asUint8List();
    await controller.addImage("location_pin", list);

    widget.onMapCreated?.call();
  }

  _onStyleLoaded() {
    _animationController.forward();
    widget.onStyleLoaded?.call();
  }

  @override
  Widget build(BuildContext context) {
    return PermissionBuilder(
      permission: Permission.location,
      builder: (context, snapshot) {
        return FadeTransition(
          opacity: _animation,
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final accessToken = AppConstants.MAPBOX_ACCESS_TOKEN;
              final style = Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.MAPBOX_DARK_STYLE_URL
                  : AppConstants.MAPBOX_LIGHT_STYLE_URL;

              return MapboxMap(
                key: GlobalKeys.mapbox,
                accessToken: accessToken,
                styleString: style,
                initialCameraPosition: widget.initialCameraPosition,
                cameraTargetBounds: widget.cameraTargetBounds,
                compassEnabled: false,
                tiltGesturesEnabled: widget.tiltGesturesEnabled,
                rotateGesturesEnabled: widget.rotateGesturesEnabled,
                zoomGesturesEnabled: widget.zoomGesturesEnabled,
                scrollGesturesEnabled: widget.scrollGesturesEnabled,
                trackCameraPosition: true,
                myLocationEnabled: widget.disableUserLocation
                    ? false
                    : snapshot.data == PermissionStatus.granted,
                onMapCreated: _onMapCreated,
                onStyleLoaded: _onStyleLoaded,
                onCameraIdle: () {
                  widget.onCameraIdle?.call(_mapController.cameraPosition);
                },
                onMapClick: widget.onMapClick?.call,
                onMapLongClick: widget.onMapLongClick?.call,
              );
            },
          ),
        );
      },
    );
  }
}

class CountriesMapController with ChangeNotifier {
  _CountriesMapState state;

  void setState(_CountriesMapState state) {
    this.state = state;
  }

  Future<Symbol> addPin(LatLng coordinates, {bool clearBefore}) {
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
        geometry: LatLng(pin.lat, pin.lng),
        iconImage: state.iconImage,
        iconSize: state.iconSize,
        iconColor: '#fffff',
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

  Future<void> animateCameraToPin(Pin pin) {
    return animateCamera(CameraUpdate.newLatLngZoom(pin.toLatLng(), 8));
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
