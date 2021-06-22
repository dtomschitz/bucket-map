import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:bucket_map/utils/utils.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CountryScreen extends StatefulWidget {
  CountryScreen({this.country});
  final Country country;

  @override
  State createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.country.name),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [Map(widget.country)],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CreatePinScreen(),
            ),
          );
        },
      ),
    );
  }
}

class Map extends StatelessWidget {
  Map(this.country);

  final Country country;
  final CountriesMapController controller = CountriesMapController();

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(Radius.circular(16));
    final targetBounds =
        GeoUtils.calculateLatLngBounds(context, country).bounds;
    return Container(
      height: 215,
      //height: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => FullScreenMap(country),
                ),
              );*/
              //Navigator.pop(context);
            },
            child: AbsorbPointer(
              child: Opacity(
                opacity: .87,
                child: Hero(
                  tag: 'country_screen_map',
                  child: CountriesMap(
                    controller: controller,
                    initialCameraPosition: CameraPosition(
                      target: country.latLng,
                      zoom: 1,
                    ),
                    cameraTargetBounds: CameraTargetBounds(targetBounds),
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    disableUserLocation: true,
                    onStyleLoaded: () async {
                      await controller.setUnlockedCountries([country.code]);
                      await controller.animateCameraToCountry(country);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenMap extends StatelessWidget {
  FullScreenMap(this.country);
  final Country country;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(country.name),
      ),
      body: Hero(
        tag: 'country_screen_map',
        child: CountriesMap(
          zoomGesturesEnabled: false,
          scrollGesturesEnabled: false,
          disableUserLocation: true,
        ),
      ),
    );
  }
}
