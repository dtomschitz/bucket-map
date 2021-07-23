part of countries.screens;

class CountriesMapScreen extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: CountriesMapScreen());

  @override
  State createState() => _CountriesMapScreenState();
}

class _CountriesMapScreenState extends State<CountriesMapScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CountriesMapScreen> {
  final SlidingSheetController sheetController = new SlidingSheetController();
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
        onSearchBarFocused: onSearchBarFocused,
        onSearchBarClose: onSearchBarClose,
      ),
      body: CountriesSlidingSheet(
        mode: _mode,
        controller: sheetController,
        animationController: _animationController,
        onHeaderTap: onHeaderTap,
        onCountryTap: onCountryTap,
        onPanelClose: onPanelClose,
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
                  initProfileListener();
                  initLocationsListener();
                },
              ),
              CreatePinButton(),
            ],
          ),
        ),
      ),
    );
  }

  initProfileListener() {
    _profileSubscription = BlocProvider.of<ProfileBloc>(context).stream.listen(
      (state) {
        if (state is ProfileLoaded) {
          mapController.setUnlockedCountries(state.profile.unlockedCountries);
        }
      },
    );
  }

  initLocationsListener() {
    _pinsSubscription =
        BlocProvider.of<LocationsBloc>(context).stream.listen((state) {
      if (state is LocationsLoaded) {
        mapController.addLocations(state.locations);
      }
    });
  }

  onSearchBarFocused() async {
    setState(() {
      _clearSearchBarOnClose = true;
      if (sheetController.isPanelClosed) {
        _mode = CountriesSlidingSheetMode.search;
      }
    });
    await sheetController.open();
  }

  onSearchBarClose() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    searchTextController.clear();
    await sheetController.close();
  }

  onCountryTap(Country country) async {
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
    sheetController.close();
  }

  onHeaderTap() async {
    setState(() => _mode = CountriesSlidingSheetMode.unlock);
    await sheetController.open();
  }

  onPanelClose() {
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
