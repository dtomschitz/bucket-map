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

    final data = await rootBundle.loadString('assets/countries.geojson');
    final features = await featuresFromGeoJson(data);

    List<Country> countries = features.collection
        .map((feature) => Country.fromGeoJsonFeature(feature))
        .toList();

    yield CountriesLoaded(countries);
  }
}
