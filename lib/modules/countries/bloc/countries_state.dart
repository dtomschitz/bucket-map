/*import 'package:equatable/equatable.dart';
import 'package:bucket_map/modules/countries/models/models.dart';

abstract class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object> get props => [];
}

class CountryInitial extends CountriesState {}

class CountryFailure extends CountriesState {}

class CountrySuccess extends CountriesState {
  final List<Country> countries;

  const CountrySuccess({
    this.countries,
  });

  CountrySuccess copyWith({
    List<Country> countries,
  }) {
    return CountrySuccess(
      countries: countries ?? this.countries,
    );
  }

  @override
  List<Object> get props => [countries];

  @override
  String toString() => 'CountrySuccess { countries: ${countries.length} }';
}*/