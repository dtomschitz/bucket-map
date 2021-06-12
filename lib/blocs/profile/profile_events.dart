part of blocs.profile;

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile(this.id);
  final String id;

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'LoadProfile { id: $id }';
}

class UnlockCountry extends ProfileEvent {
  const UnlockCountry(this.code);
  final String code;

  @override
  List<Object> get props => [code];

  @override
  String toString() => 'UnlockCountry { code: $code }';
}
