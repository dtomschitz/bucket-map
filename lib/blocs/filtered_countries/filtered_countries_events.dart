part of blocs.filtered_countries;

abstract class CountriesFilterEvent extends Equatable {
  const CountriesFilterEvent();
}

class UpdateCountriesFilter extends CountriesFilterEvent {
  const UpdateCountriesFilter(this.filter);

  final String filter;

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateCountriesFilter { filter: $filter }';
}

class ClearCountriesFilter extends CountriesFilterEvent {
  const ClearCountriesFilter();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ClearCountriesFilter { filter: empty }';
}

class FilteredCountriesUpdated extends CountriesFilterEvent {
  const FilteredCountriesUpdated(this.countries);

  final List<Country> countries;

  @override
  List<Object> get props => [countries];

  @override
  String toString() => 'FilteredCountriesUpdated';
}
