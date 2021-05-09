part of blocs.filtered_countries;

class FilteredCountriesBloc extends Bloc<FilteredCountriesEvent, FilteredCountriesState> {
  FilteredCountriesBloc({@required this.countriesBloc}) : super(FilteredCountriesInitialState());
  final CountriesBloc countriesBloc;



  @override
  Stream<FilteredCountriesState> mapEventToState(FilteredCountriesEvent event) async* {
    if (event is FilterCountriesEvent) {
      yield* _loadFilteredCountries(event.filterString);
    }
  }

  Stream<FilteredCountriesState> _loadFilteredCountries(String filterString) async* {
    yield FilteredCountriesFiltering();
    List<Country> filteredList = (countriesBloc.state as CountriesLoaded).countries
                .where(
                    (p) => p.name.toLowerCase().contains(filterString.toLowerCase()))
                .toList();
    yield FilteredCountriesFiltered(filteredList);
  }
}