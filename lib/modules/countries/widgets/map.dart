import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  State createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  MapType _mapType = MapType.normal;

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 1,
  );

  static final _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: _mapType,
          initialCameraPosition: _initialCameraPosition,
          trafficEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
            }
          },
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 56,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Nach Länder oder Region suchen..',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      child: Icon(Icons.layers_outlined),
                      mini: true,
                      backgroundColor: Color.fromARGB(230, 255, 255, 255),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(height: 200, child: Text('Tetst'));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

/*class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  State createState() => _MapState();
}

class _MapState extends State<Map> {
  MapboxMapController _controller;

  void _onMapCreated(MapboxMapController controller) {
    _controller = controller;
    _controller.addLayer('country-boundaries', 'country-label');
   //_controller.add
    /*_controller.addFill(FillOptions(
      fillColor: 'red',
      fillOpacity: 1,
      fillOutlineColor: 'red',
      
      geometry: [
        [LatLng(-67.13734351262877, 45.137451890638886)],
        [LatLng(-66.96466, 44.8097)],
        [LatLng(-68.03252, 44.3252)],
        [LatLng(-69.06, 43.98)],
        [LatLng(-70.11617, 43.68405)],
        [LatLng(-70.64573401557249, 43.090083319667144)],
      ]
    ));

    _controller.addImageSource(imageSourceId, bytes, coordinates)*/

    _controller.addFill(
      FillOptions(geometry: [
        [
          LatLng(-33.719, 151.150),
          LatLng(-33.858, 151.150),
          LatLng(-33.866, 151.401),
          LatLng(-33.747, 151.328),
          LatLng(-33.719, 151.150),
        ],
        [
          LatLng(-33.762, 151.250),
          LatLng(-33.827, 151.250),
          LatLng(-33.833, 151.347),
          LatLng(-33.762, 151.250),
        ]
      ], fillColor: "#FF0000", fillOutlineColor: "#FF0000"),
    );

    /*
    [-67.13734351262877, 45.137451890638886],
[-66.96466, 44.8097],
[-68.03252, 44.3252],
[-69.06, 43.98],
[-70.11617, 43.68405],
[-70.64573401557249, 43.090083319667144],
[-70.75102474636725, 43.08003225358635],
[-70.79761105007827, 43.21973948828747],
[-70.98176001655037, 43.36789581966826],
[-70.94416541205806, 43.46633942318431],
[-71.08482, 45.3052400000002],
[-70.6600225491012, 45.46022288673396],
[-70.30495378282376, 45.914794623389355],
[-70.00014034695016, 46.69317088478567],
[-69.23708614772835, 47.44777598732787],
[-68.90478084987546, 47.184794623394396],
[-68.23430497910454, 47.35462921812177],
[-67.79035274928509, 47.066248887716995],
[-67.79141211614706, 45.702585354182816],
[-67.13734351262877, 45.137451890638886]*/
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: AppConstants.MAPBOX_ACCESS_TOKEN,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: onStyleLoadedCallback,
      initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
      compassEnabled: false,
      rotateGesturesEnabled: false,
    
    );
  }

  void onStyleLoadedCallback() {}
}
*/
