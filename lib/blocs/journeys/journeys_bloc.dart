part of blocs.journeys;

class JourneysBloc extends Bloc<JourneysEvent, JourneysState> {
  JourneysBloc({
    @required AuthenticationRepository authenticationRepository,
    @required JourneysRepository journeysRepository,
  })  : _authenticationRepository = authenticationRepository,
        _journeysRepository = journeysRepository,
        super(JourneysStateUninitialized()) {
    _subscription = _authenticationRepository.user.listen((user) {
      add(LoadJourneys(user.id));
    });
  }

  final AuthenticationRepository _authenticationRepository;
  final JourneysRepository _journeysRepository;

  StreamSubscription _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @override
  Stream<JourneysState> mapEventToState(JourneysEvent event) async* {
    if (event is LoadJourneys) {
      yield* _mapLoadJourneysToState();
    } else if (event is JourneysUpdated) {
      yield* _mapJourneysUpdatedToState(event);
    }
  }

  Stream<JourneysState> _mapLoadJourneysToState() async* {
    _subscription?.cancel();
    _subscription = _journeysRepository
        .journeys(_authenticationRepository.currentUser.id)
        .listen((journeys) => add(JourneysUpdated(journeys)));
  }

  Stream<JourneysState> _mapJourneysUpdatedToState(
      JourneysUpdated event) async* {
    yield JourneysLoaded(event.journeys);
  }
}
