part of blocs.filtered_countries;

@immutable
abstract class FilteredCountriesState extends Equatable {
  const FilteredCountriesState();

  @override
  List<Object> get props => [];
}

class FilteredCountriesLoading extends FilteredCountriesState {
  @override
  String toString() => 'FilteredCountriesLoading';
}

class FilteredCountriesLoaded extends FilteredCountriesState {
  const FilteredCountriesLoaded({
    this.countries,
    this.filter,
  });

  final List<Country> countries;
  final String filter;

  @override
  List<Object> get props => [countries, filter];

  @override
  String toString() {
    final length = countries.length;
    return 'FilteredCountriesLoaded';
  }
}
