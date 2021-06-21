part of blocs.countries;

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc() : super(CountriesUninitialized());

  @override
  Stream<CountriesState> mapEventToState(CountriesEvent event) async* {
    if (event is LoadCountriesEvent) {
      yield* _mapLoadCountriesToState();
    }
  }

  Stream<CountriesState> _mapLoadCountriesToState() async* {
    yield CountriesLoading();

    List<dynamic> json = jsonDecode(await _loadCountriesAssets());
    List<Country> countries = json.map((c) => Country.fromJson(c)).toList();

    yield CountriesLoaded(countries);
  }
  
  Future<String> _loadCountriesAssets() {
    return rootBundle.loadString('assets/countries.json');
  }
}
