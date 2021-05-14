import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/screens/create_pin.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

class CountriesScreen extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: CountriesScreen());

  @override
  State createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  PanelController _panelController;
  TextEditingController _textController;
  MapboxMapController _mapController;

  bool _fullScreenCountriesSheet = false;
  bool _elevateAppHeader = false;
  bool _ignoreOnPanelSlide = false;

  _onListItemEyeTap(Country country){
    print(country.name);
    _fullScreenCountriesSheet = false;
    _panelController.close();
    _mapController.moveCamera(CameraUpdate.newLatLngZoom(country.latLng, 3));
    FocusScope.of(context).unfocus();
    _textController.clear();
    BlocProvider.of<FilteredCountriesBloc>(context).add(FilterUpdated(""));
  }

  _onSearchBarFocused(){
    _fullScreenCountriesSheet = true;
    _panelController.open();
  }

  _onMapCreated(MapboxMapController controller){
    _mapController = controller;
  }

  _onTextFieldCreated(TextEditingController controller) {
    _textController = controller;
  }

  _onSlidingSheetCreated(PanelController controller) {
    _panelController = controller;
  }

  _onPanelSlide(double progress) {
    if (progress == 0.0) {
      setState(() => _ignoreOnPanelSlide = false);
    }

    if (!_ignoreOnPanelSlide) {
      if (progress > 0.9 && !_fullScreenCountriesSheet) {
        setState(() {
          _fullScreenCountriesSheet = true;
        });
      }

      if (progress < 0.85 && _fullScreenCountriesSheet) {
        setState(() {
          _fullScreenCountriesSheet = false;
        });
      }
    }
  }

  _onPanelUpdateScroll(ScrollMetrics metrics) {
    if (metrics.extentBefore > 1 && !_elevateAppHeader) {
      setState(() {
        _elevateAppHeader = true;
      });
    }

    if (metrics.extentBefore < 1 && _elevateAppHeader) {
      setState(() {
        _elevateAppHeader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarBackgroundColor = _fullScreenCountriesSheet
        ? Theme.of(context).appBarTheme.backgroundColor
        : Colors.transparent;

    final appBarElevation = _elevateAppHeader ? 8.0 : 0.0;

    final searchBarType = _fullScreenCountriesSheet
        ? CountriesSearchBarType.flat
        : CountriesSearchBarType.elevated;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: appBarElevation,
        title: Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimatedContainer(
                width: _fullScreenCountriesSheet ? kMinInteractiveDimension : 0,
                duration: Duration(milliseconds: 100),
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: Icon(Icons.close_outlined),
                    onPressed: () {
                      setState(() {
                        _fullScreenCountriesSheet = false;
                        _elevateAppHeader = false;
                        _ignoreOnPanelSlide = true;
                      });
                      _panelController.close();
                      _textController.clear();
                      BlocProvider.of<FilteredCountriesBloc>(context).add(FilterUpdated(""));
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
              Expanded(
                child: CountriesSearchBar(
                  onTextFieldCreated: _onTextFieldCreated,
                  onFocused: _onSearchBarFocused,
                  type: searchBarType,
                ),
              )
            ],
          ),
        ),
      ),
      body: CountriesSlidingSheet(
        body: Stack(
          children: [
            CountriesMap(key: GlobalKeys.countriesMap, onMapCreated: _onMapCreated),
            CreatePinButton()
            ,
          ],
        ),
        onSlidingSheetCreated: _onSlidingSheetCreated,
        onPanelSlide: _onPanelSlide,
        onPanelUpdateScroll: _onPanelUpdateScroll,
        onListItemEyeTap: _onListItemEyeTap,
      ),
    );
  }
}

class CreatePinButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight + 32,
          right: 16,
        ),
        child: FloatingActionButton(
          child: Icon(Icons.create),
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
      ),
    );
  }
}
