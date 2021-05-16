part of blocs.filtered_countries;

class FilteredCountriesBloc
    extends Bloc<CountriesFilterEvent, FilteredCountriesState> {
  FilteredCountriesBloc({@required this.countriesBloc})
      : super(countriesBloc.state is CountriesLoaded
            ? FilteredCountriesLoaded(
                (countriesBloc.state as CountriesLoaded).countries, "")
            : FilteredCountriesLoading()) {
    countriesSubscription = countriesBloc.stream.listen((state) {
      if (state is CountriesLoaded) {
        add(FilteredCountriesUpdated(
            (countriesBloc.state as CountriesLoaded).countries));
      }
    });
  }

  final CountriesBloc countriesBloc;
  StreamSubscription countriesSubscription;

  @override
  Future<void> close() {
    countriesSubscription.cancel();
    return super.close();
  }

  @override
  Stream<FilteredCountriesState> mapEventToState(
      CountriesFilterEvent event) async* {
    if (event is UpdateCountriesFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is ClearCountriesFilter) {
      yield* _mapClearFilterToState(event);
    } else if (event is FilteredCountriesUpdated) {
      yield* _mapCountriesToState(event);
    }
  }

  Stream<FilteredCountriesState> _mapUpdateFilterToState(
    UpdateCountriesFilter event,
  ) async* {
    if (countriesBloc.state is CountriesLoaded) {
      yield FilteredCountriesLoaded(
        _filterCountries(
          (countriesBloc.state as CountriesLoaded).countries,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredCountriesState> _mapClearFilterToState(
    ClearCountriesFilter event,
  ) async* {
    if (countriesBloc.state is CountriesLoaded) {
      final filter = "";
      yield FilteredCountriesLoaded(
        _filterCountries(
          (countriesBloc.state as CountriesLoaded).countries,
          filter,
        ),
        filter,
      );
    }
  }

  Stream<FilteredCountriesState> _mapCountriesToState(
    FilteredCountriesUpdated event,
  ) async* {
    final filter = state is FilteredCountriesLoaded
        ? (state as FilteredCountriesLoaded).filter
        : "";

    yield FilteredCountriesLoaded(
      _filterCountries(
        (countriesBloc.state as CountriesLoaded).countries,
        filter,
      ),
      filter,
    );
  }

  List<Country> _filterCountries(
    List<Country> countries,
    String filter,
  ) {
    return countries.where((country) {
      return country.name.toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }
}
