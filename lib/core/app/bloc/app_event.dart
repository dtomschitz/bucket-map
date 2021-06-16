part of blocs.app;

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppUserChanged extends AppEvent {
  @visibleForTesting
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class UserPasswordChanged extends AppEvent {
  const UserPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}


class AppLogoutRequested extends AppEvent {}