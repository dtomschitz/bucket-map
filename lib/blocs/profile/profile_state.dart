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

  ProfileLoaded copyWith({
    Profile profile,
    User user,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'ProfileLoaded';
  }
}

class ProfileError extends ProfileState {
  const ProfileError(this.error);
  final String error;

  @override
  String toString() => 'ProfileError';
}
