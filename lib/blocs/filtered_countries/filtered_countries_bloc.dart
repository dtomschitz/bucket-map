part of blocs.filtered_countries;

class FilteredCountriesBloc
    extends Bloc<CountriesFilterEvent, FilteredCountriesState> {
  FilteredCountriesBloc({@required this.profileBloc})
      : super(profileBloc.state is ProfileLoaded
            ? FilteredCountriesLoaded(
                countries: (profileBloc.state as ProfileLoaded).countries,
                filter: "",
              )
            : FilteredCountriesLoading()) {
    _subscription = profileBloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        add(FilteredCountriesUpdated(state.countries));
      }
    });
  }

  final ProfileBloc profileBloc;
  StreamSubscription _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
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
    if (profileBloc.state is ProfileLoaded) {
      var countries = (profileBloc.state as ProfileLoaded).countries;

      yield FilteredCountriesLoaded(
        countries: _filterCountries(countries, event.filter),
        filter: event.filter,
      );
    }
  }

  Stream<FilteredCountriesState> _mapClearFilterToState(
    ClearCountriesFilter event,
  ) async* {
    if (profileBloc.state is ProfileLoaded) {
      var countries = (profileBloc.state as ProfileLoaded).countries;
      var filter = "";

      yield FilteredCountriesLoaded(
        countries: _filterCountries(countries, filter),
        filter: filter,
      );
    }
  }

  Stream<FilteredCountriesState> _mapCountriesToState(
    FilteredCountriesUpdated event,
  ) async* {
    var countries = (profileBloc.state as ProfileLoaded).countries;
    var filter = state is FilteredCountriesLoaded
        ? (state as FilteredCountriesLoaded).filter
        : "";

    yield FilteredCountriesLoaded(
      countries: _filterCountries(countries, filter),
      filter: filter,
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
