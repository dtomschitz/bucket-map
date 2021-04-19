part of blocs.auth;

@immutable
abstract class AuthEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class AuthVerify extends AuthEvent {
  @override
  String toString() => 'AppStarted';
}

class AuthLoggedIn extends AuthEvent {
  @override
  String toString() => 'AuthLoggedIn';
}

class AuthLoggedOut extends AuthEvent {
  @override
  String toString() => 'AuthLoggedOut';
}