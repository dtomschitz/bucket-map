part of blocs.profile;

@immutable
abstract class CountriesState {
  const CountriesState();
}

class CountriesUninitialized extends CountriesState {
  @override
  String toString() => 'CountriesUninitialized';
}

class CountriesLoading extends CountriesState {
  @override
  String toString() => 'CountriesLoading';
}

class CountriesLoaded extends CountriesState {
  const CountriesLoaded({this.countries, this.viewPort});

  final List<Country> countries;
  final ViewPort viewPort;

  CountriesLoaded copyWith({List<Country> countries, Country country}) {
    return CountriesLoaded(
      countries: countries ?? this.countries,
      viewPort: country ?? this.viewPort,
    );
  }

  @override
  String toString() {
    var count = countries.length;
    return 'CountriesLoaded { count: $count }';
  }
}

class CountriesError extends CountriesState {
  const CountriesError(this.error);
  final String error;

  @override
  String toString() => 'CountriesError { error: $error }';
}
