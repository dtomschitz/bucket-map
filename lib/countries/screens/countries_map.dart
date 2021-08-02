part of countries.screens;

enum CountriesMapScreenMode { Overview, Create }

class CountriesMapScreen extends StatefulWidget {
  CountriesMapScreen({Key key}) : super(key: key);

  @override
  State createState() => _CountriesMapScreenState();
}

class _CountriesMapScreenState extends State<CountriesMapScreen>
    with SingleTickerProviderStateMixin {
  final CountriesMapController mapController = new CountriesMapController();

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
              onPressed: () async {
                //final country = await CountrySearch.show(context);
                //UnlockedCountriesScreen.show(context);
              },
            ),
          ],
        ),
      ),
      body: CountriesMap(
        key: GlobalKeys.countriesMap,
        controller: mapController,
        onStyleLoaded: () {
          _initProfileListener();
          _initLocationsListener();
        },
        onMapClick: (point, coordinates) async {
          // await mapController.addPin(coordinates, clearBefore: true);
        },
        onCameraIdle: (position) {
          BlocProvider.of<CountriesBloc>(context)
              .add(UpdateViewPortCountry(position));
        },
      ),
      floatingActionButton: UnlockCountryFab(),
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

  _initLocationsListener() {
    _locationsSubscription =
        BlocProvider.of<PinsBloc>(context).stream.listen((state) {
      if (state is PinsLoaded) {
        mapController.addPins(state.pins);
      }
    });
  }
}
