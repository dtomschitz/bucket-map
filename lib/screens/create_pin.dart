import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

import 'package:bucket_map/core/constants.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePinScreen extends StatefulWidget {
  Function(Symbol symbol) openSymbolMenu;

  CreatePinScreen(Function(Symbol symbol) openSymbolMenu) : super();

  @override
  State createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  MapboxMapController _mapController;

  LatLng currentMarkerPosition;

  @override
  void initState() {
    super.initState();
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

  void _onStyleLoadedCallback() {}

  addPin(Point<double> point, LatLng position) async {
    /*
    final ByteData bytes = await rootBundle.load("assets/location_pin.png");
    final Uint8List list = bytes.buffer.asUint8List();
    await _mapController.addImage("assetImage", list);*/

    _mapController.clearSymbols();
    SymbolOptions options = SymbolOptions(
      geometry: position,
      iconImage: "airport-15",
      iconSize: 5,
      draggable: true,
    );
    _mapController.addSymbol(options);
    print("added pin");
  }

  @override
  Widget build(BuildContext context) {
    return PermissionBuilder(
      permission: Permission.location,
      builder: (context, snapshot) {
        bool isLocationGranted = snapshot.data.isGranted;
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
              child: isLocationGranted
                  ? Icon(Icons.my_location)
                  : Icon(Icons.location_disabled),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
