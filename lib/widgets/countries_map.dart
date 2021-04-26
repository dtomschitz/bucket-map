import 'package:bucket_map/core/constants.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';

class CountriesMap extends StatefulWidget {
  double fabHeight;
  Symbol createdPin;
  CountriesMap({Key key, this.fabHeight, this.createdPin}) : super(key: key);

  @override
  State createState() => _CountriesMapState();
}

class _CountriesMapState extends State<CountriesMap> {
  MapboxMapController _mapController;

  static final initialCameraPosition = CameraPosition(
    target: LatLng(0.0, 0.0),
  );

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

  @override
  void initState() {
    super.initState();
    this.modifyPin = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    
    allPins.add(widget.createdPin.options);
    _mapController.addSymbols(allPins);
    print("test");
  }

  void _onStyleLoadedCallback() {
    /*_mapController.setFilter(
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
    );*/
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

  gotoCreatePin(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePinScreen()),
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
      body: PermissionBuilder(
        permission: Permission.location,
        builder: (context, snapshot) {
          return Stack(
            children: [
              MapboxMap(
                key: GlobalKeys.mapbox,
                accessToken: AppConstants.MAPBOX_ACCESS_TOKEN,
                styleString: AppConstants.MAPBOX_LIGHT_STYLE_URL,
                initialCameraPosition: initialCameraPosition,
                compassEnabled: false,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
                trackCameraPosition: true,
                myLocationEnabled: snapshot.data == PermissionStatus.granted,
                myLocationRenderMode: MyLocationRenderMode.GPS,
                myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoadedCallback,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 120),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    opacity: true ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 250),
                    child: FloatingActionButton(
                      child: Icon(Icons.near_me_outlined),
                      mini: true,
                      onPressed: _moveCameraToCurrentLocation,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: widget.fabHeight >= screenHeight * 0.4
              ? screenHeight * 0.4
              : widget.fabHeight,
        ),
        child: ExpandableFloatingActionButton(
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
