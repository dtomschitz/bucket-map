import 'dart:async';

import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/blocs/profile/bloc.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/screens/create_location.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CountriesScreenMap extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: CountriesScreenMap());

  @override
  State createState() => _CountriesScreenMapState();
}

class _CountriesScreenMapState extends State<CountriesScreenMap>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CountriesScreenMap> {
  final PanelController panelController = new PanelController();
  final CountriesMapController mapController = new CountriesMapController();
  final TextEditingController searchTextController = TextEditingController();

  AnimationController _animationController;
  CountriesSlidingSheetMode _mode;
  bool _clearSearchBarOnClose = true;

  StreamSubscription _profileSubscription;
  StreamSubscription _pinsSubscription;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _profileSubscription.cancel();
    _pinsSubscription.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CountriesSearchAppBar(
        controller: searchTextController,
        animationController: _animationController,
        onSearchBarFocused: _onSearchBarFocused,
        onSearchBarClose: _onSearchBarClose,
      ),
      body: CountriesSlidingSheet(
        mode: _mode,
        controller: panelController,
        animationController: _animationController,
        onHeaderTap: _onHeaderTap,
        onCountryTap: _onCountryTap,
        onPanelClose: _onPanelClose,
        body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight + 48,
          ),
          child: Stack(
            children: [
              CountriesMap(
                key: GlobalKeys.countriesMap,
                controller: mapController,
                onMapLongClick: (point, latLng) async {
                  //final country = await GeoUtils.fetchCountry(latLng);
                  //print(country);
                },
                onStyleLoaded: () {
                  _initProfileListener();
                  _initPinsListener();
                },
              ),
              CreatePinButton(),
            ],
          ),
        ),
      ),
    );
  }

  _initProfileListener() {
    _profileSubscription = BlocProvider.of<ProfileBloc>(context).stream.listen(
      (state) {
        if (state is ProfileLoaded) {
          mapController.setUnlockedCountries(state.profile.unlockedCountries);
        }
      },
    );
  }

  _initPinsListener() {
    _pinsSubscription =
        BlocProvider.of<PinsBloc>(context).stream.listen((state) {
      if (state is PinsLoaded) {
        mapController.addPins(state.pins);
      }
    });
  }

  _onSearchBarFocused() async {
    setState(() {
      _clearSearchBarOnClose = true;
      if (panelController.isPanelClosed) {
        _mode = CountriesSlidingSheetMode.search;
      }
    });
    await panelController.open();
  }

  _onSearchBarClose() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    searchTextController.clear();
    await panelController.close();
  }

  _onCountryTap(Country country) async {
    setState(() => _clearSearchBarOnClose = false);

    if (_mode == CountriesSlidingSheetMode.unlock) {
      BlocProvider.of<ProfileBloc>(context).add(UnlockCountry(country.code));
      return;
    }

    searchTextController.text = country.name;

    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    BlocProvider.of<FilteredCountriesBloc>(context).add(ClearCountriesFilter());
    mapController.animateCameraToCountry(country);
    panelController.close();
  }

  _onHeaderTap() async {
    setState(() => _mode = CountriesSlidingSheetMode.unlock);
    await panelController.open();
  }

  _onPanelClose() {
    setState(() => _mode = CountriesSlidingSheetMode.unlock);
    BlocProvider.of<FilteredCountriesBloc>(context).add(ClearCountriesFilter());

    if (_clearSearchBarOnClose) {
      searchTextController.clear();
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
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => CreateLocationScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
