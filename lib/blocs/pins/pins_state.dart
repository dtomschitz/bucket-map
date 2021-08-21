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

  List<Pin> getPinsByCountry(Country country) {
    return pins.where((pin) => pin.country == country.code).toList();
  }

  @override
  List<Object> get props => [pins];

  @override
  String toString() {
    return 'PinsLoaded';
  }
}

class PinsError extends PinsState {
  const PinsError(this.error);
  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PinsError ';
}
