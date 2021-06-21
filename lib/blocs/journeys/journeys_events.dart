part of blocs.journeys;

abstract class JourneysEvent extends Equatable {
    const JourneysEvent();
}

class LoadJourneys extends JourneysEvent {
  const LoadJourneys(this.userId);
  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'LoadProfile { userId: $userId }';
}

class JourneysUpdated extends JourneysEvent {
  const JourneysUpdated(this.journeys);

  final List<Journey> journeys;

  @override
  List<Object> get props => [journeys];

  @override
  String toString() => 'JourneysUpdated { journeys: $journeys }';
}