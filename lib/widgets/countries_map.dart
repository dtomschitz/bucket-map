import 'dart:math';

import 'package:bucket_map/core/constants.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/core/settings/bloc/bloc.dart';
import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/utils/utils.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';

class CountriesMap extends StatefulWidget {
  const CountriesMap({
    Key key,
    this.controller,
    this.onMapClick,
    this.onMapLongClick,
    this.locationPadding,
    this.locationAlignment,
    this.onMapCreated,
    this.onStyleLoaded,
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
  final Function(Point<double>, LatLng) onMapClick;
  final Function(Point<double>, LatLng) onMapLongClick;
  final Function() onStyleLoaded;

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
  State createState() => _CountriesMapState();
}

class _CountriesMapState extends State<CountriesMap>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<CountriesMap> {
  MapboxMapController _mapController;
  AnimationController _animationController;
  Animation<double> _animation;

  CameraPosition _currentCameraPosition;
  bool _ignoreCameraUpdate = false;

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

    CountriesMapController _controller = widget.controller;
    if (_controller != null) {
      _controller.setUnlockedCountries = _setUnlockedCountries;
      _controller.moveCameraToPosition = _moveCameraToPosition;
      _controller.moveCameraToCountry = _moveCameraToCountry;
      _controller.animateCamera = _animateCamera;
      _controller.animateCameraToCountry = _animateCameraToCountry;
      _controller.addPin = _addPin;
      _controller.removePin = _removePin;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    widget.onMapCreated?.call();

    _mapController.addListener(() {
      if (_currentCameraPosition != _mapController.cameraPosition &&
          !_ignoreCameraUpdate) {
        setState(() {
          _currentCameraPosition = null;
          _ignoreCameraUpdate = true;
        });
      }
    });
  }

  _onStyleLoaded() {
    _animationController.forward();
    widget.onStyleLoaded?.call();
  }

  Future<void> _setUnlockedCountries(List<String> countries) async {
    if (countries.isEmpty) {
      return;
    }

    return _mapController.setFilter(
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

  Future<bool> _moveCameraToPosition(LatLng position, {double zoom}) {
    return _animateCamera(CameraUpdate.newLatLngZoom(
      position,
      zoom ?? 13,
    ));
  }

  Future<bool> _moveCameraToCountry(Country country) {
    final cameraUpdate = GeoUtils.calculateLatLngBounds(
      context,
      country,
    ).cameraUpdate;

    return _mapController.moveCamera(cameraUpdate);
  }


  Future<bool> _animateCamera(CameraUpdate cameraUpdate) {
    return _mapController.animateCamera(cameraUpdate);
  }

  Future<void> _animateCameraToCountry(Country country) async {
    final cameraUpdate = GeoUtils.calculateLatLngBounds(
      context,
      country,
    ).cameraUpdate;

    print(cameraUpdate);

    return _mapController.animateCamera(cameraUpdate);
  }

  Future<Symbol> _addPin(LatLng geometry, {bool clearBefore}) {
    if (clearBefore) {
      _mapController.clearSymbols();
    }

    return _mapController.addSymbol(SymbolOptions(
      geometry: geometry,
      iconImage: "airport-15",
      iconSize: 1.3,
      draggable: true,
    ));
  }

  Future<void> _removePin(Symbol symbol) {
    return _mapController.removeSymbol(symbol);
  }

  _moveCameraToCurrentLocation() async {
    if (await Permission.location.isGranted) {
      Position positon = await Geolocator.getCurrentPosition();
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(positon.latitude, positon.longitude),
        13,
      );
      await _mapController.animateCamera(cameraUpdate);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final locationPadding = widget.locationPadding ??
        EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight + 32,
        );

    final locationAlignment =
        widget.locationAlignment ?? Alignment.bottomCenter;

    return PermissionBuilder(
      permission: Permission.location,
      builder: (context, snapshot) {
        return Stack(
          children: [
            FadeTransition(
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
                    onMapClick: widget.onMapClick?.call,
                    onMapLongClick: widget.onMapLongClick?.call,
                  );
                },
              ),
            ),
            widget.disableUserLocation != null
                ? Container()
                : PermissionBuilder(
                    permission: Permission.location,
                    builder: (context, snapshot) {
                      if (snapshot.data == PermissionStatus.granted) {
                        return Padding(
                          padding: locationPadding,
                          child: Align(
                            alignment: locationAlignment,
                            child: FloatingActionButton(
                              child: Icon(Icons.near_me_outlined),
                              mini: true,
                              onPressed: _moveCameraToCurrentLocation,
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CountriesMapController {
  /// Starts an animated change of the map camera position
  /// to the given [LatLng] position.
  ///
  /// The returned [Future] completes after the change has been started on the
  /// platform side.
  /// It returns true if the camera was successfully moved and
  /// false if the movement was canceled.
  Future<bool> Function(LatLng position, {double zoom}) moveCameraToPosition;

  Future<bool> Function(Country country) moveCameraToCountry;

  /// Starts an animated change of the map camera position.
  ///
  /// The returned [Future] completes after the change has been started on the
  /// platform side.
  /// It returns true if the camera was successfully moved and
  /// false if the movement was canceled.
  Future<bool> Function(CameraUpdate) animateCamera;

  Future<void> Function(Country country) animateCameraToCountry;

  Future<void> Function(List<String> countries) setUnlockedCountries;

  Future<Symbol> Function(LatLng geometry, {bool clearBefore}) addPin;

  Future<void> Function(Symbol symbol) removePin;

}
