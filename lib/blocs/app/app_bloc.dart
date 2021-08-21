part of blocs.app;

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    @required AuthRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotAnonymous
              ? AppState.authenticated(authenticationRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    _userSubscription = _authenticationRepository.user.listen((user) {
      add(UserChanged(user));
    });
  }

  final AuthRepository _authenticationRepository;
  StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is UserChanged) {
      yield _mapUserChangedToState(event, state);
    } else if (event is LogoutRequested) {
      await _authenticationRepository.logOut();
    }
  }

  AppState _mapUserChangedToState(UserChanged event, AppState state) {
    return event.user.isNotAnonymous
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }
}
