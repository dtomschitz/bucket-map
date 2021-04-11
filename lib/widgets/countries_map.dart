import 'dart:io';

import 'package:bucket_map/config/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CountriesMap extends StatefulWidget {
  const CountriesMap({Key key}) : super(key: key);

  @override
  State createState() => _CountriesMapState();
}

class _CountriesMapState extends State<CountriesMap> {
  MapboxMapController _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoadedCallback() {}

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: AppConstants.MAPBOX_ACCESS_TOKEN,
      initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
      styleString: new File("assets/style.json").path,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoadedCallback,
    );
  }
}
