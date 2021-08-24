part of blocs.app;

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class UserChanged extends AppEvent {
  const UserChanged(this.user);
  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserChanged';
}

class LogoutRequested extends AppEvent {
  @override
  String toString() => 'LogoutRequested';
}
