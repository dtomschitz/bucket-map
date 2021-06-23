part of blocs.pins;

abstract class PinsEvents {
  const PinsEvents();
}

class LoadPins extends PinsEvents {
  const LoadPins(this.userId);
  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'LoadPins { userId: $userId }';
}

class PinsUpdated extends PinsEvents {
  const PinsUpdated(this.pins);
  final List<Pin> pins;

  @override
  List<Object> get props => [pins];

  @override
  String toString() => 'PinsUpdated { pins: $pins }';
}

class AddPin extends PinsEvents {
  const AddPin({this.pin});
  final Pin pin;

  @override
  List<Object> get props => [pin];

  @override
  String toString() => 'AddPin { pin: $pin }';
}

class UpdatePin extends PinsEvents {
  const UpdatePin({this.pin});
  final Pin pin;

  @override
  List<Object> get props => [pin];

  @override
  String toString() => 'UpdatePin { pin: $pin }';
}

class RemovePin extends PinsEvents {
  RemovePin({this.pin});
  final Pin pin;

  @override
  List<Object> get props => [pin];

  @override
  String toString() => 'RemovePin { pin: $pin }';
}
