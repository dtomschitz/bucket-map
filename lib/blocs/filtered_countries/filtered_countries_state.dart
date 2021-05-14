  
part of blocs.filtered_countries;

@immutable
abstract class FilteredCountriesState extends Equatable {
  const FilteredCountriesState();

  @override
  List<Object> get props => [];
}

class FilteredCountriesLoading extends FilteredCountriesState {}

class FilteredCountriesLoaded extends FilteredCountriesState {
  final List<Country> filteredCountries;
  final String filter;

  const FilteredCountriesLoaded(
    this.filteredCountries,
    this.filter,
  );

  @override
  List<Object> get props => [filteredCountries, filter];

  @override
  String toString() {
    return 'FilteredCountriesLoadSuccess { filteredCountries: $filteredCountries, filter: $filter }';
  }
}
