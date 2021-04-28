part of blocs.countries;

@immutable
abstract class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object> get props => [];
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
  final List<Country> countries;
  const CountriesLoaded(this.countries);

  CountriesLoaded copyWith({
    List<Country> countries,
  }) {
    return CountriesLoaded(countries ?? this.countries);
  }

  @override
  String toString() {
    return 'CountriesLoaded[countries: $countries]';
  }

  @override
  List<Object> get props => [countries];
}

class CountriesError extends CountriesState {
  final String error;
  const CountriesError(this.error);

  @override
  String toString() => 'CountriesError[error: $error]';

  @override
  List<Object> get props => [error];
}