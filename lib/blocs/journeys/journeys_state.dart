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
  const JourneysLoaded(this.journeys);

  final List<Journey> journeys;

  JourneysLoaded copyWith({
    List<Journey> journeys,
  }) {
    return JourneysLoaded(journeys ?? this.journeys);
  }

  @override
  String toString() {
    return 'JourneysLoaded[journeys: $journeys]';
  }

  @override
  List<Object> get props => [journeys];
}

class JourneysError extends JourneysState {
  final String error;
  const JourneysError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'JourneysError[error: $error]';
}