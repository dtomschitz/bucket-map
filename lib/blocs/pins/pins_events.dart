part of blocs.locations;

abstract class PinEvent extends Equatable {
  const PinEvent();

  @override
  List<Object> get props => [];
}

class LoadPins extends PinEvent {
  const LoadPins(this.userId);
  final String userId;

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'LoadPins { userId: $userId }';
}

class PinsUpdated extends PinEvent {
  const PinsUpdated(this.pins);
  final List<Pin> pins;

  @override
  List<Object> get props => [pins];

  @override
  String toString() => 'PinsUpdated { pins: $pins }';
}

class AddPin extends PinEvent {
  const AddPin({this.pin});
  final Pin pin;

  @override
  List<Object> get props => [pin];

  @override
  String toString() => 'AddPin { pin: $pin }';
}

class UpdatePin extends PinEvent {
  const UpdatePin({this.pin});
  final Pin pin;

  @override
  List<Object> get props => [pin];

  @override
  String toString() => 'UpdatePin { pin: $pin }';
}

class RemovePin extends PinEvent {
  RemovePin({this.pin});
  final Pin pin;

  @override
  List<Object> get props => [pin];

  @override
  String toString() => 'RemovePin { pin: $pin }';
}
