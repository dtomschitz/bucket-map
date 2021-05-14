part of blocs.filtered_countries;

abstract class FilteredCountriesEvent extends Equatable{
  const FilteredCountriesEvent();
}

class FilterUpdated extends FilteredCountriesEvent {
  const FilterUpdated(this.filter);

  final String filter;

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterUpdated { filter: $filter }';
}

class CountriesUpdated extends FilteredCountriesEvent {
  const CountriesUpdated(this.countries);

  final List<Country> countries;

  @override
  List<Object> get props => [countries];

  @override
  String toString() => 'CountriesUpdated { countries: $countries }';
}
