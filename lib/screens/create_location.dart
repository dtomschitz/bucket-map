import 'dart:convert';

import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/models/city.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/country_input_field.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class CreateLocationScreen extends StatelessWidget {
  final CountriesMapController mapController = new CountriesMapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Ziel auswählen'),
      ),
      body: CountriesMap(
        controller: mapController,
        onMapClick: (point, position) async {
          Symbol symbol = await mapController.addPin(
            position,
            clearBefore: true,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaveLocation(symbol),
            ),
          );
        },
      ),
    );
  }
}

class SaveLocation extends StatefulWidget {
  SaveLocation(this.symbol);
  final Symbol symbol;

  @override
  State createState() => _SaveLocationState();
}

class _SaveLocationState extends State<SaveLocation> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  City _city;
  Country _country;

  @override
  void initState() {
    super.initState();
    calculateNearestCity(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Ziel speichern'),
        actions: [
          TextButton(
            child: Text('Speichern'),
            onPressed: () async {
              BlocProvider.of<PinsBloc>(context).add(
                AddPin(
                  pin: Pin(
                    name: nameController.text,
                    country: _city.country,
                    lat: widget.symbol.options.geometry.latitude,
                    lng: widget.symbol.options.geometry.longitude,
                  ),
                ),
              );

              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded && _city != null) {
            return ListViewContainer(
              title: 'Weitere Informationen',
              subtitle:
                  'Um die Location zu speichern, muss noch ein Name festgelegt werden.',
              children: [
                InputField(
                  controller: nameController,
                  labelText: 'Name',
                ),
                SizedBox(height: 32),
              ],
            );
          }

          return TopCircularProgressIndicator();
        },
      ),
    );
  }

  calculateNearestCity(Symbol symbol) async {
    List<dynamic> json = jsonDecode(
      await rootBundle.loadString('assets/cities.json'),
    );

    List<City> cities = json.map((c) => City.fromJson(c)).toList();
    City city;

    double lowestDistance = 5000000;
    double distance;
    var cityListIter = cities.iterator;

    while (cityListIter.moveNext()) {
      distance = Geolocator.distanceBetween(
        cityListIter.current.latLng.latitude,
        cityListIter.current.latLng.longitude,
        symbol.options.geometry.latitude,
        symbol.options.geometry.longitude,
      );

      if (distance < lowestDistance) {
        lowestDistance = distance;
        city = cityListIter.current;
      }
    }

    setState(() => _city = city);
  }
}
