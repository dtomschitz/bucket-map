import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/screens/create_pin.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CountriesScreen extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: CountriesScreen());

  @override
  State createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final CountriesMapController _mapController = new CountriesMapController();
  final TextEditingController _searchTextController = TextEditingController();

  PanelController _panelController;

  CountriesSlidingSheetMode _mode;
  bool _fullScreenCountriesSheet = false;
  bool _elevateAppHeader = false;
  bool _ignoreOnPanelSlide = false;

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
      appBar: CountriesSearchAppBar(
        type: type,
        controller: _searchTextController,
        backgroundColor: backgroundColor,
        elevation: elevation,
        showCloseButton: _fullScreenCountriesSheet,
        onClose: _onSearchBarClose,
        onSearchBarFocused: _onSearchBarFocused,
      ),
      body: CountriesSlidingSheet(
        //mode: _mode,
        body: Stack(
          children: [
            CountriesMap(
              key: GlobalKeys.countriesMap,
              controller: _mapController,
            ),
            CreatePinButton(),
          ],
        ),
        onSlidingSheetCreated: _onSlidingSheetCreated,
        onPanelSlide: _onPanelSlide,
        onPanelUpdateScroll: _onPanelUpdateScroll,
        onCountryTap: _onCountryTap,
      ),
    );
  }

  _onSearchBarClose() {
    _panelController.close();
    _searchTextController.clear();

    BlocProvider.of<FilteredCountriesBloc>(context).add(FilterUpdated(""));
  }

  _onSearchBarFocused() {
    setState(() => _mode = CountriesSlidingSheetMode.search);
    _panelController.open();
  }

  _onCountryTap(Country country) {
    print(country);
    _searchTextController.clear();
    FocusScope.of(context).unfocus();
    BlocProvider.of<FilteredCountriesBloc>(context).add(FilterUpdated(""));

    _panelController.close();
    _mapController.moveCameraToPosition(country.latLng);
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
        setState(() => _fullScreenCountriesSheet = true);
      }

      if (progress < 0.85 && _fullScreenCountriesSheet) {
        setState(() => _fullScreenCountriesSheet = false);
      }
    }
  }

  _onPanelUpdateScroll(ScrollMetrics metrics) {
    if (metrics.extentBefore > 1 && !_elevateAppHeader) {
      setState(() => _elevateAppHeader = true);
    }

    if (metrics.extentBefore < 1 && _elevateAppHeader) {
      setState(() => _elevateAppHeader = false);
    }
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
