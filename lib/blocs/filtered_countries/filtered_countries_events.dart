part of blocs.filtered_countries;

abstract class FilteredCountriesEvent extends Equatable{
  const FilteredCountriesEvent();
}


class FilterUpdated extends FilteredCountriesEvent {
  final String filter;

  const FilterUpdated(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterUpdated { filter: $filter }';
}

class CountriesUpdated extends FilteredCountriesEvent {
  final List<Country> countries;

  const CountriesUpdated(this.countries);

  @override
  List<Object> get props => [countries];

  @override
  String toString() => 'CountriesUpdated { countries: $countries }';
}
