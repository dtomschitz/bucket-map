part of blocs.pins;

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

class PinAdding extends PinsState {
  @override
  String toString() => 'PinAdding';
}

class PinsLoaded extends PinsState {
  final List<Pin> pins;
  const PinsLoaded(this.pins);

  PinsLoaded copyWith({
    List<Pin> pins,
  }) {
    return PinsLoaded(pins ?? this.pins);
  }

  @override
  String toString() {
    return 'PinsLoaded[pins: $pins]';
  }

  @override
  List<Object> get props => [pins];
}

class PinsError extends PinsState {
  final String error;
  const PinsError(this.error);

  @override
  String toString() => 'PinsError[error: $error]';

  @override
  List<Object> get props => [error];
}
