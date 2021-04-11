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

    /*List<dynamic> decodedJson = jsonDecode(await _loadCountriesAssets());
    List<Country> countries = decodedJson.map((c) => Country.fromJson(c));

    print(countries.length);*/

    // yield CountriesLoaded(countries);
  }

  Future<String> _loadCountriesAssets() {
    return rootBundle.loadString('assets/countries.json');
  }
}
