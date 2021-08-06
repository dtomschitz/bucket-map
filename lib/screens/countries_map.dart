part of screens;

enum CountriesMapScreenMode { Default, CreatePin }

class CountriesMapScreen extends StatefulWidget {
  CountriesMapScreen({Key key}) : super(key: key);

  @override
  State createState() => _CountriesMapScreenState();
}

class _CountriesMapScreenState extends State<CountriesMapScreen>
    with TickerProviderStateMixin {
  final CountriesMapController mapController = CountriesMapController();

  AnimationController _animationController;
  Animation _animation;

  StreamSubscription _profileSubscription;
  StreamSubscription _pinsSubscription;
  StreamSubscription _eventsSubscription;

  CountriesMapScreenMode _mode = CountriesMapScreenMode.Default;
  Symbol _currentSymbol;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _eventsSubscription = EventProvider.of(context).events.listen((event) {
      if (event is AppBarVisibility) {
        if (event.show) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      }

      if (event is ShowCreatePinSheet) {
        setState(() => _mode = CountriesMapScreenMode.CreatePin);
      }

      if (event is HideCreatePinSheet) {
        setState(() => _mode = CountriesMapScreenMode.Default);

        if (_currentSymbol != null) {
          mapController.removePin(_currentSymbol);
        }
      }
    });
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    _pinsSubscription?.cancel();
    _eventsSubscription?.cancel();

    _animationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
          child: _mode == CountriesMapScreenMode.Default
              ? Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.account_box_outlined),
                      onPressed: () {
                        ProfileScreen.show(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search_outlined),
                      onPressed: () async {
                        final country = await CountrySearch.show(context);
                        if (country != null) {
                          mapController.animateCameraToCountry(country);
                        }
                      },
                    ),
                    CurrentCountry(),
                    IconButton(
                      icon: Icon(Icons.settings_outlined),
                      onPressed: () {
                        SettingsScreen.show(context);
                      },
                    ),
                  ],
                )
              : Container(),
        ),
      ),
      body: CountriesMap(
        key: GlobalKeys.countriesMap,
        controller: mapController,
        onStyleLoaded: () {
          _initProfileListener();
          _initPinsListener();
        },
        onMapClick: (point, coordinates) async {
          CreatePinScreen.show(context, coordinates);
          /*if (_currentSymbol != null) {
              mapController.removePin(_currentSymbol);
            }

            Symbol symbol = await mapController.addPin(coordinates);
            setState(() => _currentSymbol = symbol);

            mapController.animateCameraToCoordinates(
              coordinates,
              minZoom: true,
            );

            dispatchEvent(
              context,
              ShowCreatePinSheet(
                coordinates: coordinates,
              ),
            );*/
        },
        onCameraIdle: (position) {
          BlocProvider.of<CountriesBloc>(context)
              .add(UpdateViewPortCountry(position));
        },
        onCameraPositionChanged: (position) {
          // dispatchEvent(context, MinimizeCreatePinSheet());
        },
      ),
      /*body: CreatePinSheet(
        child: CountriesMap(
          key: GlobalKeys.countriesMap,
          controller: mapController,
          onStyleLoaded: () {
            _initProfileListener();
            _initPinsListener();
          },
          onMapClick: (point, coordinates) async {
            /*if (_currentSymbol != null) {
              mapController.removePin(_currentSymbol);
            }

            Symbol symbol = await mapController.addPin(coordinates);
            setState(() => _currentSymbol = symbol);

            mapController.animateCameraToCoordinates(
              coordinates,
              minZoom: true,
            );

            dispatchEvent(
              context,
              ShowCreatePinSheet(
                coordinates: coordinates,
              ),
            );*/
          },
          onCameraIdle: (position) {
            BlocProvider.of<CountriesBloc>(context)
                .add(UpdateViewPortCountry(position));
          },
          onCameraPositionChanged: (position) {
            // dispatchEvent(context, MinimizeCreatePinSheet());
          },
        ),
      ),*/
      floatingActionButton: _mode == CountriesMapScreenMode.CreatePin
          ? FloatingActionButton.extended(
              label: Text('Speichern'),
              onPressed: () {},
            )
          : null,
    );
  }

  _initProfileListener() {
    var bloc = BlocProvider.of<ProfileBloc>(context);
    var state = bloc.state;

    if (state is ProfileLoaded) {
      var countries = state.profile.unlockedCountries;
      mapController.setUnlockedCountries(countries);
    }

    _profileSubscription = bloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        mapController.setUnlockedCountries(state.profile.unlockedCountries);
      }
    });
  }

  _initPinsListener() {
    var bloc = BlocProvider.of<PinsBloc>(context);
    var state = bloc.state;

    if (state is PinsLoaded) {
      mapController.addPins(state.pins);
    }

    _pinsSubscription = bloc.stream.listen((state) {
      if (state is PinsLoaded) {
        mapController.addPins(state.pins);
      }
    });
  }
}
