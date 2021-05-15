import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/models/models.dart';
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
  final TextEditingController _searchTextController = TextEditingController();

  PanelController _panelController;
  MapboxMapController _mapController;

  bool _fullScreenCountriesSheet = false;
  bool _elevateAppHeader = false;
  bool _ignoreOnPanelSlide = false;

  _onSearchBarFocused() {
    _fullScreenCountriesSheet = true;
    _panelController.open();
  }

  _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
  }

  _onSlidingSheetCreated(PanelController controller) {
    _panelController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final type = _fullScreenCountriesSheet
        ? SearchBarType.flat
        : SearchBarType.transparent;

    final backgroundColor = _fullScreenCountriesSheet
        ? Theme.of(context).appBarTheme.backgroundColor
        : Colors.transparent;

    final elevation = _elevateAppHeader ? 8.0 : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SearchAppBar(
        type: type,
        controller: _searchTextController,
        backgroundColor: backgroundColor,
        elevation: elevation,
        showCloseButton: _fullScreenCountriesSheet,
        onClose: () {
          setState(() {
            _fullScreenCountriesSheet = false;
            _elevateAppHeader = false;
            _ignoreOnPanelSlide = true;
          });

          _panelController.close();
          _searchTextController.clear();

          BlocProvider.of<FilteredCountriesBloc>(context)
              .add(FilterUpdated(""));
        },
        onSearchBarFocused: _onSearchBarFocused,
      ),
      body: CountriesSlidingSheet(
        body: CountriesMap(fabHeight: _fabHeight, onMapCreated: _onMapCreated),
        onSlidingSheetCreated: _onSlidingSheetCreated,
        onPanelSlide: _onPanelSlide,
        onPanelUpdateScroll: _onPanelUpdateScroll,
        onCountryTap: _onCountryTap,
      ),
    );
  }

  _onCountryTap(Country country) {
   print(country.name);
    _fullScreenCountriesSheet = false;
    _panelController.close();
    _mapController.moveCamera(CameraUpdate.newLatLngZoom(country.latLng, 3));
    FocusScope.of(context).unfocus();
    _searchTextController.clear();
    BlocProvider.of<FilteredCountriesBloc>(context).add(FilterUpdated(""));
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
}

enum SearchBarType { transparent, flat }

class SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  SearchAppBar({
    this.type,
    this.controller,
    this.backgroundColor,
    this.elevation,
    this.onSearchBarFocused,
    this.onClose,
    this.showCloseButton = false,
    this.height = kToolbarHeight,
  });

  final SearchBarType type;
  final TextEditingController controller;

  final Color backgroundColor;
  final double elevation;
  final double height;
  final bool showCloseButton;

  final Function onSearchBarFocused;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      title: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AnimatedContainer(
              width: showCloseButton ? kMinInteractiveDimension : 0,
              duration: Duration(milliseconds: 100),
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Icon(Icons.close_outlined),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    onClose();
                  },
                ),
              ),
            ),
            Expanded(
              child: CountriesSearchBar(
                type: type,
                controller: controller,
                onFocused: onSearchBarFocused,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class CountriesSearchBar extends StatelessWidget {
  CountriesSearchBar({this.type, this.controller, this.onFocused});

  final SearchBarType type;
  final TextEditingController controller;
  final Function onFocused;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: type == SearchBarType.flat
            ? BorderSide(color: Colors.white, width: 1.0)
            : BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(50),
      ),
      elevation: type == SearchBarType.flat ? 4 : 0,
      child: Container(
        height: 46,
        width: double.infinity,
        padding: EdgeInsets.only(right: 16, left: 16),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.search_outlined),
            ),
            Expanded(
              child: FocusScope(
                child: Focus(
                  onFocusChange: (focus) {
                    if (focus) onFocused();
                  },
                  child: CountriesTextField(
                    controller: controller,
                    onChange: (value) {
                      BlocProvider.of<FilteredCountriesBloc>(context)
                          .add(FilterUpdated(value));
                    },
                    onClear: () {
                      BlocProvider.of<FilteredCountriesBloc>(context)
                          .add(FilterUpdated(""));
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CountriesTextField extends StatelessWidget {
  CountriesTextField({this.controller, this.onChange, this.onClear});

  final TextEditingController controller;
  final Function(String value) onChange;
  final Function() onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChange,
      decoration: InputDecoration(
        labelText: 'Search country',
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            FocusScope.of(context).unfocus();
            controller.clear();

            onClear();
          },
        ),
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
