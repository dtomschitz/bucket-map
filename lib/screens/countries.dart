import 'dart:async';

import 'package:bucket_map/blocs/filtered_countries/bloc.dart';
import 'package:bucket_map/blocs/profile/bloc.dart';
import 'package:bucket_map/core/global_keys.dart';
import 'package:bucket_map/models/models.dart';
import 'package:bucket_map/screens/create_pin.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum CountriesScreenMode { unlock, search, searched }

class CountriesScreen extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: CountriesScreen());

  @override
  State createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen>
    with SingleTickerProviderStateMixin {
  final PanelController panelController = new PanelController();
  final CountriesMapController mapController = new CountriesMapController();
  final TextEditingController searchController = TextEditingController();

  CountriesScreenMode mode = CountriesScreenMode.unlock;
  AnimationController animationController;
  StreamSubscription profileSubscription;

  bool clearSearchBarOnClose = true;

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    profileSubscription.cancel();
    super.dispose();
  }

  initProfileListener() {
    profileSubscription =
        BlocProvider.of<ProfileBloc>(context).stream.listen((state) {
      if (state is ProfileLoaded) {
        mapController.setUnlockedCountries(state.profile.unlockedCountries);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CountriesSearchAppBar(
        mode: mode,
        controller: searchController,
        animationController: animationController,
        onSearchBarTap: onSearchBarTap,
        onSearchBarClose: onSearchBarClose,
      ),
      body: CountriesSlidingSheet(
        controller: panelController,
        animationController: animationController,
        onHeaderTap: _onHeaderTap,
        onPanelClose: _onPanelClose,
        body: Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).padding.bottom + kToolbarHeight + 126,
          ),
          child: Stack(
            children: [
              CountriesMap(
                key: GlobalKeys.countriesMap,
                controller: mapController,
                onStyleLoaded: () {
                  initProfileListener();
                },
                onMapClick: (point, location) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => CreatePinScreen(),
                    ),
                  );
                },
              ),
              CreatePinButton(),
            ],
          ),
        ),
      ),
    );
  }

  onSearchBarTap() async {
    setState(() {
      clearSearchBarOnClose = true;
      mode = panelController.isPanelClosed
          ? CountriesScreenMode.search
          : CountriesScreenMode.unlock;
    });

    if (mode == CountriesScreenMode.search) {
      final Country country = await showSearch(
        context: context,
        delegate: CountrySearchDelegate(),
      );

      setState(() => mode = CountriesScreenMode.searched);

      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }

      if (country != null) {
        searchController.text = country.name;
        mapController.animateCameraToCountry(country);
      }
    }
  }

  onSearchBarClose() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }


    searchController.clear();
    await panelController.close();
  }

  _onHeaderTap() async {
    setState(() => mode = CountriesScreenMode.unlock);

    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    searchController.clear();
    await panelController.open();
  }

  _onPanelClose() {
    setState(() => mode = CountriesScreenMode.unlock);
    BlocProvider.of<FilteredCountriesBloc>(context).add(ClearCountriesFilter());

    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    if (clearSearchBarOnClose) {
      searchController.clear();
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
