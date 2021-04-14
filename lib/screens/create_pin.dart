import 'dart:io';
import 'dart:math';

import 'package:bucket_map/config/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

import 'package:bucket_map/widgets/countries_map.dart';

class CreatePinScreen extends StatefulWidget {
  CreatePinScreen() : super();

  @override
  State createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  MapboxMapController _mapController;

  bool locationPermissionGranted = false;
  LatLng currentMarkerPosition;

  @override
  void initState() {
    super.initState();
    getPermission();
    currentMarkerPosition = new LatLng(45.45, 45.45);
  }

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(0.0, 0.0),
  );

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
  }

  getPermission() async* {
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.checkPermissions(
            [Permission.ACCESS_FINE_LOCATION]);
    if (permission.entries.first.value == PermissionState.GRANTED) {
      setState(() {
        locationPermissionGranted = true;
      });
    }
    locationPermissionGranted = false;
  }

  void _onStyleLoadedCallback() {}

  addPin(Point<double> point, LatLng position) {
    _mapController.clearSymbols();
    _mapController.addSymbol(SymbolOptions(
      geometry: position,
      iconImage: "airport-15",
      iconSize: 1.3,
      draggable: true,
    ));
    print("added pin");
  }

  @override
  Widget build(BuildContext context) {
    getPermission();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 60.0,
        title: Text(
          'Click to create a Pin at any Location.',
          style: TextStyle(fontSize: 14.0),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Symbol sym = _mapController.symbols.first;
              sym.options =
                  sym.options.copyWith(new SymbolOptions(draggable: false));
              Navigator.pop(context, sym);
            },
            child: Text("Ok"),
          ),
        ],
      ),
      body: MapboxMap(
        accessToken: AppConstants.MAPBOX_ACCESS_TOKEN,
        initialCameraPosition: _initialCameraPosition,
        styleString: new File("assets/style.json").path,
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoadedCallback,
        onMapClick: (point, latlng) {
          addPin(point, latlng);
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          child: locationPermissionGranted
              ? Icon(Icons.my_location)
              : Icon(Icons.location_disabled),
          onPressed: () {},
        ),
      ),
    );
  }
}
