part of blocs.profile;

@immutable
abstract class CountriesState {
  const CountriesState();
}

class CountriesUninitialized extends CountriesState {
  @override
  String toString() => 'CountriesUninitialized';
}

class CountriesLoading extends CountriesState {
  @override
  String toString() => 'CountriesLoading';
}

class CountriesLoaded extends CountriesState {
  const CountriesLoaded({this.countries, this.viewPort});

  final List<Country> countries;
  final ViewPortCountry viewPort;

  CountriesLoaded copyWith({List<Country> countries, Country country}) {
    return CountriesLoaded(
      countries: countries ?? this.countries,
      viewPort: country ?? this.viewPort,
    );
  }

  List<Country> get unlockedCountries {
    return this.countries.where((country) {
      return country.unlocked;
    }).toList();
  }

  List<Country> get recentUnlockedCountries {
    var unlockedCountries = this.countries.where((country) {
      return country.unlocked;
    }).toList();

    var countries = List.of(unlockedCountries);
    countries.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return countries.take(5).toList();
  }

  @override
  String toString() {
    var count = countries.length;
    return 'CountriesLoaded';
  }
}

class CountriesError extends CountriesState {
  const CountriesError(this.error);
  final String error;

  @override
  String toString() => 'CountriesError';
}
