part of blocs.journeys;

class JourneysBloc extends Bloc<JourneysEvent, JourneysState> {
  JourneysBloc({@required JourneysRepository journeysRepository})
      : _journeysRepository = journeysRepository,
        super(JourneysStateUninitialized());

  final JourneysRepository _journeysRepository;
  StreamSubscription _journeysSubscription;

  @override
  Stream<JourneysState> mapEventToState(JourneysEvent event) async* {
    if (event is LoadJourneysEvent) {}
  }

  @override
  Future<void> close() {
    _journeysSubscription?.cancel();
    return super.close();
  }

  Stream<JourneysState> _mapLoadJourneysToState() async* {
    _journeysSubscription?.cancel();

    /*_journeysSubscription = _journeysRepository.journeys().listen(
          (journey) => add(TodosUpdated(todos)),
        );*/
  }
}
