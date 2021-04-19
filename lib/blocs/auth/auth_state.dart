part of blocs.auth;

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthState {
  @override
  String toString() => 'AuthUninitialized';
}

class Authenticated extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AuthSuccess';
}

class Unauthenticated extends AuthState {
  @override
  String toString() => 'AuthFailure';
}