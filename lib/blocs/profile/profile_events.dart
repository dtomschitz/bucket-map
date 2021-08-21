part of blocs.profile;

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile(this.user);
  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoadProfile';
}

class ProfileUpdated extends ProfileEvent {
  const ProfileUpdated({this.profile, this.user});

  final Profile profile;
  final User user;

  @override
  List<Object> get props => [profile];

  @override
  String toString() => 'ProfileUpdated';
}

class UnlockCountry extends ProfileEvent {
  const UnlockCountry(this.code);
  final String code;

  @override
  List<Object> get props => [code];

  @override
  String toString() => 'UnlockCountry';
}

class UpdateProfile extends ProfileEvent {
  const UpdateProfile({this.profile});
  final Profile profile;

  @override
  List<Object> get props => [profile];

  @override
  String toString() => 'UpdateProfile';
}

class ResetProfileState extends ProfileEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'ResetProfileState';
}
