import 'dart:math';
import 'dart:typed_data';

import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

  _saveCurrentSymbol() async {
    //TODO: Save pin in global state

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
                                ? _saveCurrentSymbol
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
}
