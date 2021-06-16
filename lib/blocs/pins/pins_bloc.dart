part of blocs.pins;

class PinsBloc extends Bloc<PinsEvents, PinsState> {
  PinsBloc() : super(PinsUninitialized());
  final databaseReference = FirebaseFirestore.instance;

  PinsBloc pinsBloc; //TODO: const or final?

  // @override
  // Stream<PinsState> mapEventToState(PinsEvents event) {
  //   // TODO: implement mapEventToState
  //   throw UnimplementedError();
  // }

  @override
  Stream<PinsState> mapEventToState(PinsEvents event) async* {
    print("LOADING PINS TO STATE-----------------------------");
    // TODO: implement mapEventToState
    if (event is LoadPinsEvent) {
      yield* _loadPinsToState();
    }
    if (event is AddPinEvent) {
      yield* _addPinToState(event);
    }
  }

  Stream<PinsState> _loadPinsToState() async* {
    yield PinsLoading();
    print("LOADING PINS TO STATE------------------------------");
    List<Pin> pins = [];
    yield PinsLoaded(pins);
  }

  Stream<PinsState> _addPinToState(AddPinEvent event) async* {
    if (pinsBloc.state is PinsLoaded) {
      List<Pin> pins = (pinsBloc.state as PinsLoaded).pins;
      yield PinAdding();
      pins.add(event.pin);
      yield PinsLoaded(pins);
    }
  }
}
