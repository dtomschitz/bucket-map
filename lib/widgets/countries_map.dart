import 'dart:math';
import 'dart:typed_data';

import 'package:bucket_map/core/constants.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/core/settings/bloc/bloc.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';

class CountriesMap extends StatefulWidget {
  const CountriesMap({
    Key key,
    this.controller,
    this.onMapClick,
    this.locationPadding,
    this.locationAlignment,
    this.onMapCreated,
    this.onStyleLoaded,
  }) : super(key: key);

  final Function() onMapCreated;
  final Function() onStyleLoaded;

  final CountriesMapController controller;
  final Function(Point<double>, LatLng) onMapClick;
  final EdgeInsets locationPadding;
  final Alignment locationAlignment;

  @override
  State createState() => _CountriesMapState();
}

class _CountriesMapState extends State<CountriesMap>
    with TickerProviderStateMixin {
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
      _controller.animateCamera = _animateCamera;
      _controller.moveCameraToPosition = _moveCameraToPosition;
      _controller.addPin = _addPin;
      _controller.addPins = _addPins;
      _controller.removePin = _removePin;
      _controller.animateCameraToCountry = _animateCameraToCountry;
    }
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
    await controller.addImage("locationPin", list);

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

  Future<void> _addPins(List<Pin> pins) async {
    final symbols = pins
        .map(
          (pin) => SymbolOptions(
            geometry: LatLng(pin.lat, pin.lng),
            iconImage: "locationPin",
            iconSize: 0.3,
            draggable: false,
          ),
        )
        .toList();

    await _mapController.addSymbols(symbols);
  }

  Future<void> _setUnlockedCountries(List<String> countries) async {
    if (countries.isEmpty) {
      return;
    }

    return _mapController.setFilter(
      'country-boundaries',
      [
        "match",
        ["get", "iso_3166_1_alpha_3"],
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

  Future<bool> _animateCamera(CameraUpdate cameraUpdate) {
    return _mapController.animateCamera(cameraUpdate);
  }

  Future<Symbol> _addPin(LatLng geometry, {bool clearBefore}) {
    if (clearBefore) {
      _mapController.clearSymbols();
    }

    return _mapController.addSymbol(SymbolOptions(
      geometry: geometry,
      iconImage: "locationPin",
      iconSize: 0.3,
      draggable: true,
    ));
  }

  Future<void> _removePin(Symbol symbol) {
    return _mapController.removeSymbol(symbol);
  }

  Future<void> _animateCameraToCountry(Country country) async {
    if (country.southwest.longitude > 0 && country.northeast.longitude < 0) {
      double lngOverflow = 180 + country.northeast.longitude;
      double lngDifference = 180 + lngOverflow - country.southwest.longitude;
      double rightPadding =
          lngOverflow / lngDifference * MediaQuery.of(context).size.width;
      LatLng modifiedNe = LatLng(country.northeast.latitude, 179.99);
      await _mapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(southwest: country.southwest, northeast: modifiedNe),
          right: rightPadding));
    } else {
      await _mapController.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: country.southwest, northeast: country.northeast)));
    }
  }

  _moveCameraToCurrentLocation() async {
    if (await Permission.location.isGranted) {
      Position positon = await Geolocator.getCurrentPosition();
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(positon.latitude, positon.longitude),
        13,
      );
      //setState(() => _ignoreCameraUpdate = true);
      await _mapController.animateCamera(cameraUpdate);
      setState(() {
        _currentCameraPosition = _mapController.cameraPosition;
        // _ignoreCameraUpdate = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    initialCameraPosition: CameraPosition(
                      target: LatLng(0.0, 0.0),
                    ),
                    compassEnabled: false,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    trackCameraPosition: true,
                    myLocationEnabled:
                        snapshot.data == PermissionStatus.granted,
                    onMapCreated: _onMapCreated,
                    onStyleLoaded: _onStyleLoaded,
                    onMapClick: widget.onMapClick,
                  );
                },
              ),
            ),
            PermissionBuilder(
              permission: Permission.location,
              builder: (context, snapshot) {
                if (snapshot.data == PermissionStatus.granted) {
                  return Padding(
                    padding: locationPadding,
                    child: Align(
                      alignment: locationAlignment,
                      child: AnimatedOpacity(
                        opacity: _currentCameraPosition == null ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 250),
                        child: FloatingActionButton(
                          child: Icon(Icons.near_me_outlined),
                          mini: true,
                          onPressed: _moveCameraToCurrentLocation,
                        ),
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

  /// Starts an animated change of the map camera position.
  ///
  /// The returned [Future] completes after the change has been started on the
  /// platform side.
  /// It returns true if the camera was successfully moved and
  /// false if the movement was canceled.
  Future<bool> Function(CameraUpdate) animateCamera;

  Future<void> Function(List<String> countries) setUnlockedCountries;

  Future<Symbol> Function(LatLng geometry, {bool clearBefore}) addPin;

  Future<void> Function(List<Pin> pin) addPins;

  Future<void> Function(Symbol symbol) removePin;

  Future<void> Function(Country country) animateCameraToCountry;
}
