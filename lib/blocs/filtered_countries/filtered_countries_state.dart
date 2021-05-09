part of blocs.filtered_countries;

@immutable
abstract class FilteredCountriesState extends Equatable {
  const FilteredCountriesState();

  @override
  List<Object> get props => [];
}

class FilteredCountriesInitialState extends FilteredCountriesState {}

class FilteredCountriesFiltered extends FilteredCountriesState {
  final List<Country> countries;
  const FilteredCountriesFiltered(this.countries);

  FilteredCountriesFiltered copyWith({
    List<Country> countries,
  }) {
    return FilteredCountriesFiltered(countries ?? this.countries);
  }

  @override
  String toString() => 'FilteredCountriesFiltered';

  @override
  List<Object> get props => [countries];
}

class FilteredCountriesFiltering extends FilteredCountriesState {}
