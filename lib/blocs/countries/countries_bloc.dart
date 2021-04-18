part of blocs.countries;

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc() : super(CountriesUninitialized());
  final databaseReference = FirebaseFirestore.instance;

  @override
  Stream<CountriesState> mapEventToState(CountriesEvent event) async* {
    if (event is LoadCountriesEvent) {
      yield* _fetchCountriesFromFirestore();
    }
  }

  Stream<CountriesState> _loadCountries() async* {
    yield CountriesUninitialized();

    /*List<dynamic> decodedJson = jsonDecode(await _loadCountriesAssets());
    List<Country> countries = decodedJson.map((c) => Country.fromJson(c));

    print(countries.length);*/

    // yield CountriesLoaded(countries);
  }

  Stream<CountriesState> _fetchCountriesFromFirestore() async* {
    yield CountriesLoading();
    QuerySnapshot countriesSnapshot = await databaseReference
      .collection("countries")
      .orderBy("name")
      .get();
    List<Country> countriesList = countriesSnapshot.docs.map<Country>((doc){
        return Country.fromJson(doc.data());
      }).toList();
    yield CountriesLoaded(countriesList);
  }

  Future<String> _loadCountriesAssets() {
    return rootBundle.loadString('assets/countries.json');
  }
}
