import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/config/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:bucket_map/utils/expandableFAB.dart';
import 'package:bucket_map/screens/createPin.dart';

class CountriesMap extends StatefulWidget {
  double fabHeight;
  Symbol createdPin;
  CountriesMap({Key key, this.fabHeight, this.createdPin}) : super(key: key);

  @override
  State createState() => _CountriesMapState();
}

class _CountriesMapState extends State<CountriesMap> {
  final key = GlobalKey();
  MapboxMapController _mapController;

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  int _symbolCount = 0;
  Symbol _selectedSymbol;

  bool modifyPin;

  bool show = false;

  double offset = 0;

  double height;

  double screenHeight;

  bool modfiyPin = false;

  List<SymbolOptions> allPins = [];

  Offset test;

  double _initFabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(0.0, 0.0),
  );

  @override
  void initState() {
    super.initState();
    this.modifyPin = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) async {
    _mapController = controller;
    allPins.add(widget.createdPin.options);
    _mapController.addSymbols(allPins);
    print("test");
  }

  void _onStyleLoadedCallback() {
    _mapController.setFilter(
      'country-boundaries',
      [
        "match",
        ["get", "iso_3166_1_alpha_3"],
        [
          "NLD",
          "AFG",
          "ALA",
          "ALB",
          "ASM",
          "ATA",
          "AIA",
          "BHR",
          "BGD",
          "BLR",
          "BEL",
          "BWA",
          "BRA",
          "BES"
        ],
        true,
        false
      ],
    );
  }

  gotoCreatePin(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePin()),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    setState(() {
      allPins.add(result.options);
    });
    _mapController.addSymbols(allPins);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    _initFabHeight = screenHeight * 0.12;
    if (widget.fabHeight == null) widget.fabHeight = _initFabHeight;
    _panelHeightOpen = screenHeight * 1;
    return Scaffold(
      body: MapboxMap(
        accessToken: AppConstants.MAPBOX_ACCESS_TOKEN,
        initialCameraPosition: _initialCameraPosition,
        styleString: new File("assets/style.json").path,
        onMapCreated: _onMapCreated,
        onStyleLoadedCallback: _onStyleLoadedCallback,
        //onStyleLoadedCallback: onStyleLoadedCallback,
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: widget.fabHeight >= screenHeight * 0.4
              ? screenHeight * 0.4
              : widget.fabHeight,
        ),
        child: ExpandableFab(
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              child: Icon(Icons.create),
              onPressed: () {
                gotoCreatePin(context);
              },
            ),
            FloatingActionButton(heroTag: "btn2", onPressed: () {}),
            FloatingActionButton(heroTag: "btn3", onPressed: () {}),
          ],
          distance: 70.0,
          initialOpen: false,
        ),
      ),
    );
  }
}

/*

floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: widget.fabHeight >= screenHeight * 0.4
              ? screenHeight * 0.4
              : widget.fabHeight,
        ),
        child: FloatingActionButton(
            child: modfiyPin ? const Icon(Icons.done) : const Icon(Icons.add),
            onPressed: () {
              setState(() {
                modfiyPin = !modfiyPin;
              });
            },
            backgroundColor: modfiyPin ? Colors.green : Colors.white),
      ),

*/
