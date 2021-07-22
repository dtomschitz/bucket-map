part of blocs.locations;

abstract class LocationEvents extends Equatable {
  const LocationEvents();

  @override
  List<Object> get props => [];
}

class LoadLocations extends LocationEvents {
  const LoadLocations(this.userId);
  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'LoadLocations { userId: $userId }';
}

class LocationsUpdated extends LocationEvents {
  const LocationsUpdated(this.locations);
  final List<Location> locations;

  @override
  List<Object> get props => [locations];

  @override
  String toString() => 'LocationsUpdated { locations: $locations }';
}

class AddLocation extends LocationEvents {
  const AddLocation({this.location});
  final Location location;

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'AddLocation { location: $location }';
}

class UpdateLocation extends LocationEvents {
  const UpdateLocation({this.location});
  final Location location;

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'UpdateLocation { location: $location }';
}

class RemoveLocation extends LocationEvents {
  RemoveLocation({this.location});
  final Location location;

  @override
  List<Object> get props => [location];

  @override
  String toString() => 'RemoveLocation { location: $location }';
}
