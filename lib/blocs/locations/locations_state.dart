part of blocs.locations;

@immutable
abstract class LocationsState extends Equatable {
  const LocationsState();

  @override
  List<Object> get props => [];
}

class LocationsUninitialized extends LocationsState {
  @override
  String toString() => 'LocationsUninitialized';
}

class LocationsLoading extends LocationsState {
  @override
  String toString() => 'LocationsLoading';
}

class LocationsLoaded extends LocationsState {
  const LocationsLoaded(this.locations);
  final List<Location> locations;

  LocationsLoaded copyWith({
    List<Location> locations,
  }) {
    return LocationsLoaded(locations ?? this.locations);
  }

  @override
  List<Object> get props => [locations];

  @override
  String toString() {
    return 'LocationsLoaded { pins: $locations }';
  }
}

class LocationsError extends LocationsState {
  const LocationsError(this.error);
  final String error;

  @override
  String toString() => 'LocationsError { error: $error }';

  @override
  List<Object> get props => [error];
}
