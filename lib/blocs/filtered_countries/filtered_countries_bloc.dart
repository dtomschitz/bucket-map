part of blocs.filtered_countries;

class FilteredCountriesBloc extends Bloc<FilteredCountriesEvent, FilteredCountriesState> {
  FilteredCountriesBloc({@required this.countriesBloc}) 
    : super(
      countriesBloc.state is CountriesLoaded
        ? FilteredCountriesLoaded(
            (countriesBloc.state as CountriesLoaded).countries,
            ""
        )
        : FilteredCountriesLoading()) {
          countriesSubscription = countriesBloc.stream.listen((state) { 
            if (state is CountriesLoaded){
              add(CountriesUpdated((countriesBloc.state as CountriesLoaded).countries));
            }
          });
        }

  final CountriesBloc countriesBloc;
  StreamSubscription countriesSubscription;

  @override
  Stream<FilteredCountriesState> mapEventToState(FilteredCountriesEvent event) async* {
    if (event is FilterUpdated) {
      yield* _mapFilterUpdatedToState(event);
    } else if (event is CountriesUpdated) {
      yield* _mapCountriesUpdatedToState(event);
    }
  }


Stream<FilteredCountriesState> _mapFilterUpdatedToState(
    FilterUpdated event,
  ) async* {
    if (countriesBloc.state is CountriesLoaded) {
      yield FilteredCountriesLoaded(
        _mapCountriesToFilteredCountries(
          (countriesBloc.state as CountriesLoaded).countries,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredCountriesState> _mapCountriesUpdatedToState(
    CountriesUpdated event,
  ) async* {
    final visibilityFilter = state is FilteredCountriesLoaded
        ? (state as FilteredCountriesLoaded).filter
        : "";

    yield FilteredCountriesLoaded(
      _mapCountriesToFilteredCountries(
        (countriesBloc.state as CountriesLoaded).countries,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

   
    List<Country> _mapCountriesToFilteredCountries(
      List<Country> countries, String filter) {
    return countries.where((country) => country.name.toLowerCase().contains(filter.toLowerCase())).toList();
  }

  @override
  Future<void> close() {
    countriesSubscription.cancel();
    return super.close();
  }
}