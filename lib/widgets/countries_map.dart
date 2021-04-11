import 'dart:io';

import 'package:bucket_map/config/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CountriesMap extends StatefulWidget {
  final bool modifyPin;
  CountriesMap({Key key, @required this.modifyPin}) : super(key: key);

  @override
  State createState() => _CountriesMapState();
}

class _CountriesMapState extends State<CountriesMap> {
  MapboxMapController _mapController;

  List<Marker> currentMarkers;
  List<Marker> allMarkers;

  LatLng currentMarkerPosition;

  bool modifyPin;

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(0.0, 0.0),
  );

  @override
  void initState() {
    super.initState();
    this.modifyPin = false;

    (currentMarkers == null) ? currentMarkers = [] : DoNothingAction();
    (allMarkers == null) ? allMarkers = [] : DoNothingAction();

    final CountriesBloc countriesBloc = BlocProvider.of<CountriesBloc>(context);
    _countriesSubscription = countriesBloc.stream.listen(
      (state) {
        if (state is CountriesLoaded) {
          //Set<Polygon> polygons = {};
          for (var country in state.countries) {
            //print(country);
            if (country.points.isNotEmpty) {
              setState(() {
                _polygons.add(
                  Polygon(
                    polygonId: PolygonId(country.name),
                    points: country.points,
                    fillColor: Color.fromARGB(50, 0, 0, 0),
                    visible: true,
                    zIndex: 2,
                    strokeWidth: 1,
                  ),
                );
              });
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
  }

  void _onStyleLoadedCallback() {}

  _handleTap(LatLng tappedPoint) {
    setState(() {
      currentMarkers.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
            setState(() {
              currentMarkerPosition = dragEndPosition;
            });
          }));
    });
  }

  _handleAddMarker(LatLng markerPosition) {
    allMarkers.add(Marker(
      markerId: MarkerId(markerPosition.toString()),
      position: markerPosition,
      draggable: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: AppConstants.MAPBOX_ACCESS_TOKEN,
      initialCameraPosition: _initialCameraPosition,
      styleString: new File("assets/style.json").path,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoadedCallback,
      //onStyleLoadedCallback: onStyleLoadedCallback,
    );*/
    return Stack(
      children: [
        GoogleMap(
          mapType: _mapType,
          initialCameraPosition: _initialCameraPosition,
          markers: modifyPin ? Set.from(currentMarkers) : Set.from(allMarkers),
          trafficEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          onTap: this.modifyPin
              ? _handleTap(currentMarkerPosition)
              : _handleAddMarker(currentMarkerPosition),
          polygons: _polygons,
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
                    child: GestureDetector(
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
                      onTap: () {
                        /*showSearch(
                          context: context,
                          delegate: CountrySearch(),
                        );*/
                      },
                    )),
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
}
