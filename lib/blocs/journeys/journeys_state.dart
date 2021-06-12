part of blocs.journeys;

@immutable
abstract class JourneysState extends Equatable {
  const JourneysState();

  @override
  List<Object> get props => [];
}

class JourneysStateUninitialized extends JourneysState {
  @override
  String toString() => 'JourneysStateUninitialized';
}

class JourneysLoading extends JourneysState {
  @override
  String toString() => 'JourneysLoading';
}

class JourneysLoaded extends JourneysState {
  final List<Country> countries;
  const JourneysLoaded(this.countries);

  JourneysLoaded copyWith({
    List<Country> countries,
  }) {
    return JourneysLoaded(countries ?? this.countries);
  }

  @override
  String toString() {
    return 'JourneysLoaded[countries: $countries]';
  }

  @override
  List<Object> get props => [countries];
}

class JourneysError extends JourneysState {
  final String error;
  const JourneysError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'JourneysError[error: $error]';
}