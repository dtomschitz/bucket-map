part of blocs.profile;

@immutable
abstract class ProfileState {
  const ProfileState();
}

class ProfileUninitialized extends ProfileState {
  @override
  String toString() => 'ProfileUninitialized';
}

class ProfileLoading extends ProfileState {
  @override
  String toString() => 'ProfileLoading';
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({this.profile, this.user});

  final Profile profile;
  final User user;

  @override
  String toString() {
    return 'ProfileLoaded { profile: $profile }';
  }
}

class ProfileError extends ProfileState {
  const ProfileError(this.error);
  final String error;

  @override
  String toString() => 'ProfileError { error: $error }';
}
