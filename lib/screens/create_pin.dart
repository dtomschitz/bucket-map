import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/core/auth/repositories/auth_repository.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/models/city.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePinScreen extends StatefulWidget {
  @override
  State createState() {
    return _CreatePinScreenState();
  }
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final CountriesMapController _controller = new CountriesMapController();

  Symbol _currentSymbol;
  bool _showClearButton = false;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _delayMapRendering();
  }

  _onMapClick(Point<double> point, LatLng position) async {
    Symbol symbol = await _controller.addPin(position, clearBefore: true);
    setState(() {
      _currentSymbol = symbol;
      _showClearButton = true;
    });
  }

  _clearCurrentSymbol() {
    _controller.removePin(_currentSymbol);
    setState(() {
      _currentSymbol = null;
      _showClearButton = false;
    });
  }

  _saveCurrentSymbol(String name, String description) async {
    List<dynamic> json =
        jsonDecode(await rootBundle.loadString('assets/cities.json'));
    List<City> cities = json.map((c) => City.fromJson(c)).toList();
    City nearestCity;
    double lowestDistance = 5000000;
    double distance;
    var cityListIter = cities.iterator;

    while (cityListIter.moveNext()) {
      distance = Geolocator.distanceBetween(
          cityListIter.current.latLng.latitude,
          cityListIter.current.latLng.longitude,
          _currentSymbol.options.geometry.latitude,
          _currentSymbol.options.geometry.longitude);
      if (distance < lowestDistance) {
        lowestDistance = distance;
        nearestCity = cityListIter.current;
      }
    }

    Pin pin = new Pin(
        name: name,
        country: nearestCity.country,
        lat: _currentSymbol.options.geometry.latitude,
        lng: _currentSymbol.options.geometry.longitude,
        description: description);
    BlocProvider.of<PinsBloc>(context).add(AddPin(pin: pin));
    _closeScreen();
  }

  _closeScreen() async {
    setState(() => _showMap = false);
    await new Future.delayed(new Duration(milliseconds: 50));

    Navigator.pop(context);
  }

  _delayMapRendering() async {
    await new Future.delayed(new Duration(milliseconds: 250));
    setState(() => _showMap = true);
  }

  @override
  Widget build(BuildContext context) {
    final locationPadding = MediaQuery.of(context).padding.bottom + 86;

    return PermissionBuilder(
      permission: Permission.location,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _closeScreen,
            ),
            title: Text('Ziel auswählen'),
            actions: [
              AnimatedOpacity(
                opacity: _showClearButton ? 1.0 : 0.0,
                duration: Duration(milliseconds: 150),
                curve: Curves.easeOutQuint,
                child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _clearCurrentSymbol,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              _showMap
                  ? CountriesMap(
                      key: GlobalKeys.countriesMap,
                      controller: _controller,
                      onMapClick: _onMapClick,
                      locationPadding: EdgeInsets.only(
                        bottom: locationPadding,
                      ),
                    )
                  : SizedBox(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  elevation: 8,
                  child: Container(
                    color: Theme.of(context).appBarTheme.color,
                    width: double.infinity,
                    child: SafeArea(
                      child: Container(
                        child: SizedBox(
                          height: 70.0,
                          child: TextButton(
                            child: Text('Speichern'),
                            onPressed: _currentSymbol != null
                                ? () => (_showSavePinDialog(context))
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSavePinDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "Name")),
                TextField(
                    controller: descriptionController,
                    minLines: 1,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Beschreibung",
                    )),
                /*DropdownButton<String>(
                  items: <String>[
                    'Deutschland',
                    'Frankreich',
                    'Russland',
                    'Italien'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  
                  onChanged: (_) {},
                )*/
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Speichern'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveCurrentSymbol(
                    nameController.text, descriptionController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
