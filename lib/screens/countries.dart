import 'dart:async';

import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/blocs/profile/bloc.dart';
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

class _CountriesScreenState extends State<CountriesScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CountriesScreen> {
  final PanelController _panelController = new PanelController();
  final CountriesMapController _mapController = new CountriesMapController();
  final TextEditingController _searchTextController = TextEditingController();

  AnimationController _animationController;
  CountriesSlidingSheetMode _mode;

  StreamSubscription _profileSubscription;

  bool _animationLock = false;
  bool _clearSearchBarOnClose = true;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CountriesSearchAppBar(
        controller: _searchTextController,
        animationController: _animationController,
        onSearchBarFocused: _onSearchBarFocused,
        onSearchBarClose: _onSearchBarClose,
      ),
      body: CountriesSlidingSheet(
        mode: _mode,
        controller: _panelController,
        animationController: _animationController,
        onHeaderTap: _onHeaderTap,
        onCountryTap: _onCountryTap,
        onPanelClose: _onPanelClose,
        body: BlocBuilder<CountriesBloc, CountriesState>(
          builder: (context, state) {
            if (state is CountriesLoaded) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom +
                      kToolbarHeight +
                      48,
                ),
                child: Stack(
                  children: [
                    CountriesMap(
                      key: GlobalKeys.countriesMap,
                      controller: _mapController,
                      onStyleLoaded: () => _initProfileListener(),
                      onMapLongClick: (point, latLng) {},
                    ),
                    CreatePinButton(),
                  ],
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _initProfileListener() {
    _profileSubscription =
        BlocProvider.of<ProfileBloc>(context).stream.listen((state) {
      if (state is ProfileLoaded) {
        _mapController.setUnlockedCountries(state.profile.unlockedCountries);
      }
    });
  }

  _onSearchBarFocused() async {
    setState(() {
      _clearSearchBarOnClose = true;
      if (_panelController.isPanelClosed) {
        _mode = CountriesSlidingSheetMode.search;
      }
    });
    await _panelController.open();
  }

  _onSearchBarClose() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    _searchTextController.clear();
    await _panelController.close();
  }

  _onCountryTap(Country country) async {
    setState(() => _clearSearchBarOnClose = false);

    if (_mode == CountriesSlidingSheetMode.unlock) {
      BlocProvider.of<ProfileBloc>(context).add(UnlockCountry(country.code));
      return;
    }
    
    _searchTextController.text = country.name;

    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    BlocProvider.of<FilteredCountriesBloc>(context).add(ClearCountriesFilter());

    _mapController.animateCameraToCountry(country);

    await _panelController.close();
  }

  _onHeaderTap() async {
    setState(() => _mode = CountriesSlidingSheetMode.unlock);
    await _panelController.open();
  }

  _onPanelClose() {
    setState(() => _mode = CountriesSlidingSheetMode.unlock);
    BlocProvider.of<FilteredCountriesBloc>(context).add(ClearCountriesFilter());

    if (_clearSearchBarOnClose) {
      _searchTextController.clear();
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
