part of screens;

enum CountriesMapScreenMode { Overview, Create }

class CountriesMapScreen extends StatefulWidget {
  CountriesMapScreen({Key key}) : super(key: key);

  @override
  State createState() => _CountriesMapScreenState();
}

class _CountriesMapScreenState extends State<CountriesMapScreen>
    with SingleTickerProviderStateMixin {
  final CountriesMapController mapController = CountriesMapController();
  final SheetController createSheetController = SheetController();

  AnimationController _animationController;
  StreamSubscription _profileSubscription;
  StreamSubscription _locationsSubscription;

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
    _profileSubscription?.cancel();
    _locationsSubscription?.cancel();
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
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.lock_outline),
              onPressed: () {
                UnlockedCountriesScreen.show(context);
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
        ),
      ),
      body: Stack(
        children: [
          CountriesMap(
            key: GlobalKeys.countriesMap,
            controller: mapController,
            onStyleLoaded: () {
              _initProfileListener();
              _initLocationsListener();
            },
            onMapClick: (point, coordinates) async {
              mapController.addPin(coordinates);
              mapController.animateCameraToCoordinates(
                coordinates,
                minZoom: true,
              );

              dispatchEvent(context, ShowCreatePinSheet());
            },
            onCameraIdle: (position) {
              BlocProvider.of<CountriesBloc>(context)
                  .add(UpdateViewPortCountry(position));
            },
            onCameraPositionChanged: (position) {},
          ),
          CreatePinSheet(),
        ],
      ),
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

  _initLocationsListener() {
    _locationsSubscription =
        BlocProvider.of<PinsBloc>(context).stream.listen((state) {
      if (state is PinsLoaded) {
        mapController.addPins(state.pins);
      }
    });
  }
}
