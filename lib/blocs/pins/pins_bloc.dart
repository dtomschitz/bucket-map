part of blocs.pins;

class PinsBloc extends Bloc<PinsEvents, PinsState> {
  PinsBloc({
    @required AuthenticationRepository authRepository,
    @required PinRepository pinRepository,
  })  : _authRepository = authRepository,
        _pinRepository = pinRepository,
        super(PinsUninitialized()) {
    _authSubscription = _authRepository.user.listen((user) {
      add(LoadPins(user.id));
    });
  }

  final AuthenticationRepository _authRepository;
  final PinRepository _pinRepository;

  StreamSubscription _authSubscription;
  StreamSubscription _pinsSubscription;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _pinsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<PinsState> mapEventToState(PinsEvents event) async* {
    print("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ");
    print(event.toString() + "sdasdadadasdasdad");
    if (event is LoadPins) {
      yield* _mapLoadPinsToState(event);
    } else if (event is AddPin) {
      yield* _mapAddPinToState(event);
    } else if (event is UpdatePin) {
      yield* _mapUpdatePinToState(event);
    } else if (event is RemovePin) {
      yield* _mapRemovePinToState(event);
    } else if (event is PinsUpdated) {
      yield* _mapPinsUpdatedToState(event);
    }
  }

  Stream<PinsState> _mapLoadPinsToState(LoadPins event) async* {
    //_pinsSubscription.cancel();
    _pinsSubscription =
        _pinRepository.pins(_authRepository.currentUser.id).listen((pins) {
      add(PinsUpdated(pins));
    });
  }

  Stream<PinsState> _mapAddPinToState(AddPin event) async* {
    _pinRepository
        .addPin(event.pin.copyWith(userId: _authRepository.currentUser.id));
  }

  Stream<PinsState> _mapUpdatePinToState(UpdatePin event) async* {
    _pinRepository.updatePin(event.pin);
  }

  Stream<PinsState> _mapRemovePinToState(RemovePin event) async* {
    _pinRepository.deletePin(event.pin);
  }

  Stream<PinsState> _mapPinsUpdatedToState(PinsUpdated event) async* {
    yield PinsLoaded(event.pins);
  }
}
