part of screens;

class CountriesMapScreen extends StatefulWidget {
  CountriesMapScreen({Key key}) : super(key: key);

  @override
  State createState() => _CountriesMapScreenState();
}

class _CountriesMapScreenState extends State<CountriesMapScreen> {
  final MapController mapController = MapController();

  StreamSubscription _profileSubscription;
  StreamSubscription _pinsSubscription;
  StreamSubscription _eventsSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    _pinsSubscription?.cancel();
    _eventsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _CountriesMapAppBar(
        onSearch: () async {
          final country = await CountrySearch.show(context);
          if (country != null) {
            mapController.animateCameraToCountry(country);
          }
        },
        onProfile: () => ProfileScreen.show(context),
        onUnlockedCountries: () => UnlockedCountriesScreen.show(context),
      ),
      body: Map(
        key: GlobalKeys.countriesMap,
        controller: mapController,
        onStyleLoaded: () {
          _initProfileListener();
          //_initPinsListener();
        },
        onMapClick: _createPin,
        onMapLongClick: _unlockCountry,
        onCameraIdle: (position, bounds) {
          _updateViewPortCountry(position);
        },
      ),
      floatingActionButton: PinsFab(),
    );
  }

  _initProfileListener() {
    var bloc = BlocProvider.of<ProfileBloc>(context);
    var state = bloc.state;

    if (state is ProfileLoaded) {
      var countries = state.profile.unlockedCountryCodes;
      mapController.setUnlockedCountries(countries);
    }

    _profileSubscription = bloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        mapController.setUnlockedCountries(state.profile.unlockedCountryCodes);
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

  _updateViewPortCountry(CameraPosition position) {
    BlocProvider.of<CountriesBloc>(context)
        .add(UpdateViewPortCountry(position));
  }

  _createPin(Point<double> point, LatLng coordinates) {
    CreatePinScreen.show(context, coordinates);
  }

  _unlockCountry(Point<double> point, LatLng coordinates) async {
    var state = BlocProvider.of<ProfileBloc>(context).state;
    if (state is ProfileLoaded) {
      final code = await GeoUtils.getCountryCode(coordinates);
      if (code != null && !state.profile.unlockedCountries.contains(code)) {
        print(code);
      }
    }
  }
}

class _CountriesMapAppBar extends StatelessWidget with PreferredSizeWidget {
  _CountriesMapAppBar({
    this.onProfile,
    this.onSearch,
    this.onUnlockedCountries,
  });
  final Function onProfile;
  final Function onSearch;
  final Function onUnlockedCountries;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),
          AppBarIconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: onProfile?.call,
          ),
          const SizedBox(width: 8),
          AppBarIconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: onSearch?.call,
          ),
          const SizedBox(width: 8),
          CurrentCountry(),
          const SizedBox(width: 8),
          AppBarIconButton(
            icon: Icon(Icons.public_outlined),
            onPressed: onUnlockedCountries?.call,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AppBarIconButton extends StatelessWidget {
  AppBarIconButton({this.icon, this.onPressed});

  final Icon icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Colors.black.withOpacity(.15),
        child: IconButton(
          constraints: BoxConstraints(maxHeight: 46),
          icon: icon,
          iconSize: 24.0,
          color: Colors.white,
          onPressed: onPressed?.call,
        ),
      ),
    );
  }
}
