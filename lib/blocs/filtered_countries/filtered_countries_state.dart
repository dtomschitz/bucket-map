  
part of blocs.filtered_countries;

@immutable
abstract class FilteredCountriesState extends Equatable {
  const FilteredCountriesState();

  @override
  List<Object> get props => [];
}

class FilteredCountriesLoading extends FilteredCountriesState {}

class FilteredCountriesLoaded extends FilteredCountriesState {
  final List<Country> countries;
  final String filter;

  const FilteredCountriesLoaded(
    this.countries,
    this.filter,
  );

  @override
  List<Object> get props => [countries, filter];

  @override
  String toString() {
    return 'FilteredCountriesLoadSuccess { filteredCountries: $countries, filter: $filter }';
  }
}
