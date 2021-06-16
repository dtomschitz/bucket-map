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
  const ProfileLoaded(this.profile);
  final Profile profile;

  @override
  String toString() {
    return 'ProfileLoaded[profile: $profile]';
  }
}

class ProfileError extends ProfileState {
  final String error;
  const ProfileError(this.error);

  @override
  String toString() => 'ProfileError[error: $error]';
}
