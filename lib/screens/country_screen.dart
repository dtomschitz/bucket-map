import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/screens/country_locations.dart';
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.lock_open_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              height: 255,
              child: Map(widget.country),
            ),
          ),
        ],
      ),
      floatingActionButton: CreatePinButton(),
    );
  }
}

class PinListItem extends StatelessWidget {
  PinListItem(this.country);
  final Country country;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('test'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {},
      child: ListTile(title: Text("TEst")),
      background: Container(
        color: Colors.red,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                "Pin löschen",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }
}

class CreatePinButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: InkWell(
          splashColor: Colors.black,
          borderRadius: borderRadius,
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, __, ___) => CountryLocations(country),
                transitionsBuilder: (context, opacity, a2, child) {
                  return FadeTransition(
                    opacity: opacity,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 250),
              ),
            );
            //Navigator.pop(context);
          },
          child: AbsorbPointer(
            child: Opacity(
              opacity: .87,
              child: CountriesMap(
                controller: controller,
                initialCameraPosition: CameraPosition(
                  target: country.latLng,
                  zoom: 1,
                ),
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                disableUserLocation: true,
                onMapCreated: () async {
                  await controller.setUnlockedCountries([country.code]);
                  Future.delayed(const Duration(milliseconds: 200), () async {
                    await controller.moveCameraToCountry(country);
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
