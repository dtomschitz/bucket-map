part of blocs.pins;

abstract class PinsEvents {
  // const PinsEvents();
}

class LoadPinsEvent extends PinsEvents {}

class AddPinEvent extends PinsEvents {
  AddPinEvent({this.pin});
  final Pin pin;

  @override
  List<Object> get props => [pin];

  @override
  String toString() => 'AddPin';
}
