part of blocs.profile;

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc({
    @required ProfileBloc profileBloc,
  })  : _profileBloc = profileBloc,
        super(CountriesUninitialized()) {
    _subscription = _profileBloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        var countries = state.profile.unlockedCountries;
        add(LoadUnlockedCountries(countries: countries));
      }
    });
  }

  final ProfileBloc _profileBloc;
  StreamSubscription _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @override
  Stream<CountriesState> mapEventToState(CountriesEvent event) async* {
    if (event is LoadCountries) {
      yield* _mapLoadCountriesToState(event);
    } else if (event is LoadUnlockedCountries) {
      yield* _mapLoadUnlockedCountriesToState(event);
    } else if (event is UpdateViewPortCountry) {
      yield* _mapUpdateViewPortCountryToState(event);
    } else if (event is ResetCountriesState) {
      yield* _mapResetCountriesStateToState();
    }
  }

  Stream<CountriesState> _mapLoadCountriesToState(LoadCountries event) async* {
    yield CountriesLoading();
    var countries = await _loadCountries();
    yield CountriesLoaded(countries: countries);
  }

  Stream<CountriesState> _mapLoadUnlockedCountriesToState(
    LoadUnlockedCountries event,
  ) async* {
    var countries = state is CountriesLoaded
        ? (state as CountriesLoaded).countries
        : await _loadCountries();

    countries = countries.map((country) {
      var unlocked = event.countries.firstWhere(
        (c) => country.code == c.code,
        orElse: () => null,
      );

      if (unlocked != null) {
        return country.copyWith(
          unlocked: true,
          dateTime: unlocked.dateTime,
        );
      }

      return country;
    }).toList();

    yield CountriesLoaded(countries: countries);
  }

  Stream<CountriesState> _mapUpdateViewPortCountryToState(
    UpdateViewPortCountry event,
  ) async* {
    if (state is CountriesLoaded) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        event.position.target.latitude,
        event.position.target.longitude,
      );

      final countries = (state as CountriesLoaded).countries;
      final placemark = placemarks.first;

      yield CountriesLoaded(
        countries: countries,
        viewPort: placemark != null
            ? ViewPortCountry(
                name: placemark.country.isNotEmpty
                    ? placemark.country
                    : placemark.name,
                code: placemark.isoCountryCode,
              )
            : null,
      );
    }
  }

  Stream<CountriesState> _mapResetCountriesStateToState() async* {
    yield CountriesUninitialized();
  }

  Future<List<Country>> _loadCountries() async {
    List<dynamic> json = jsonDecode(await _loadCountriesAssets());
    var countries = json.map((country) => Country.fromJson(country)).toList();

    return countries;
  }

  Future<String> _loadCountriesAssets() {
    return rootBundle.loadString('assets/countries.json');
  }
}
