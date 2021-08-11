part of blocs.profile;

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();
}

class LoadCountries extends CountriesEvent {
  const LoadCountries();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoadCountries';
}

class LoadUnlockedCountries extends CountriesEvent {
  const LoadUnlockedCountries({this.countries});
  final List<UnlockedCountry> countries;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'UpdateUnlockedCountries';
}

class UpdateViewPortCountry extends CountriesEvent {
  const UpdateViewPortCountry(this.position);
  final CameraPosition position;

  @override
  List<Object> get props => [position];

  @override
  String toString() => 'UpdateViewPortCountry { position: $position }';
}
