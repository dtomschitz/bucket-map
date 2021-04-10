part of blocs.countries;

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc() : super(CountriesUninitialized());

  @override
  Stream<CountriesState> mapEventToState(CountriesEvent event) async* {
    if (event is LoadCountriesEvent) {
      yield* _loadCountries();
    }
  }

  Stream<CountriesState> _loadCountries() async* {
    yield CountriesUninitialized();

    final jsonData = json.decode(await _loadCountriesAssets());
    final List<Country> countries = List<Country>.from(
      jsonData.map((country) => Country.fromJson(country)),
    );

    yield CountriesLoaded(countries);
  }

  Future<String> _loadCountriesAssets() {
    return rootBundle.loadString('assets/countries.json');
  }
}
