part of blocs.filtered_countries;

abstract class FilteredCountriesEvent {}

class FilterCountriesEvent extends FilteredCountriesEvent {
  FilterCountriesEvent({this.filterString});
  final String filterString;
}