part of widgets;

class CountriesMap extends StatefulWidget {
  const CountriesMap({
    Key key,
    this.controller,
    this.onMapCreated,
    this.onStyleLoaded,
    this.onCameraIdle,
    this.onCameraPositionChanged,
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
  final Function(CameraPosition cameraPosition) onCameraPositionChanged;

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
  final defaultZoom = 8.0;

  MapboxMapController _mapController;
  AnimationController _animationController;
  Animation<double> _animation;

  CameraPosition _cameraPosition;

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

    _mapController.addListener(() {
      if (widget.onCameraPositionChanged != null) {
        if (_cameraPosition != _mapController.cameraPosition) {
          setState(() => _cameraPosition = _mapController.cameraPosition);
          widget.onCameraPositionChanged(_cameraPosition);
        }
      }
    });

    setState(() {});

    widget.onMapCreated?.call();
  }

  _onStyleLoaded() {
    _animationController.forward();
    widget.onStyleLoaded?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final accessToken = AppConstants.MAPBOX_ACCESS_TOKEN;
          final style = Theme.of(context).brightness == Brightness.dark
              ? AppConstants.MAPBOX_DARK_STYLE_URL
              : AppConstants.MAPBOX_LIGHT_STYLE_URL;

          return GestureDetector(

            child: MapboxMap(
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
              /*myLocationEnabled: widget.disableUserLocation
                    ? false
                    : snapshot.data == PermissionStatus.granted,*/
              onMapCreated: _onMapCreated,
              onStyleLoaded: _onStyleLoaded,
              onCameraIdle: () {
                widget.onCameraIdle?.call(_mapController.cameraPosition);
              },
              onMapClick: widget.onMapClick?.call,
              onMapLongClick: widget.onMapLongClick?.call,
            ),
          );
        },
      ),
    );
  }
}
