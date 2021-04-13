import 'dart:convert';
import 'dart:io';
import 'dart:math';

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

  void _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
  }

  void _onStyleLoadedCallback() {
    _mapController.setFilter(
      'country-boundaries',
      [
        "match",
        ["get", "iso_3166_1_alpha_3"],
        ["NLD", "AFG", "ALA", "ALB", "ASM", "ATA", "AIA", "BHR", "BGD", "BLR", "BEL", "BWA", "BRA", "BES"],
        true,
        false
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: AppConstants.MAPBOX_ACCESS_TOKEN,
      initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
      styleString: new File("assets/style.json").path,
      //styleString: 'mapbox://styles/daviddo3399/cknbq7w7y0vlc17r0i37seyc3',
      onMapCreated: _onMapCreated,
      onMapIdle: () {
        print("dawdd");
      
      },
      onStyleLoadedCallback: _onStyleLoadedCallback,
    );
  }
}
