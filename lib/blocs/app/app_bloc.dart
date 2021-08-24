part of blocs.app;

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    @required AuthRepository authenticationRepository,
    @required ProfileBloc profileBloc,
    @required CountriesBloc countriesBloc,
    @required PinsBloc pinsBloc,
  })  : _authenticationRepository = authenticationRepository,
        _profileBloc = profileBloc,
        _countriesBloc = countriesBloc,
        _pinsBloc = pinsBloc,
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

  final ProfileBloc _profileBloc;
  final CountriesBloc _countriesBloc;
  final PinsBloc _pinsBloc;

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
      yield* _mapLogoutRequestedToState();
    }
  }

  AppState _mapUserChangedToState(UserChanged event, AppState state) {
    return event.user.isNotAnonymous
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated();
  }

  Stream<AppState> _mapLogoutRequestedToState() async* {
    await _authenticationRepository.logOut();

    _profileBloc.add(ResetProfileState());
    _countriesBloc.add(ResetCountriesState());
    _pinsBloc.add(ResetPinsState());
  }
}
