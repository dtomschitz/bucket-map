part of blocs.locations;

@immutable
abstract class PinsState extends Equatable {
  const PinsState();

  @override
  List<Object> get props => [];
}

class PinsUninitialized extends PinsState {
  @override
  String toString() => 'PinsUninitialized';
}

class PinsLoading extends PinsState {
  @override
  String toString() => 'PinsLoading';
}

class PinsLoaded extends PinsState {
  const PinsLoaded(this.pins);
  final List<Pin> pins;

  PinsLoaded copyWith({
    List<Pin> pins,
  }) {
    return PinsLoaded(pins ?? this.pins);
  }

  @override
  List<Object> get props => [pins];

  @override
  String toString() {
    return 'PinsLoaded { pins: $pins }';
  }
}

class PinsError extends PinsState {
  const PinsError(this.error);
  final String error;

  @override
  String toString() => 'PinsError { error: $error }';

  @override
  List<Object> get props => [error];
}
