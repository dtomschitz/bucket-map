part of blocs.locations;

class LocationsBloc extends Bloc<LocationEvents, LocationsState> {
  LocationsBloc({
    @required AuthenticationRepository authRepository,
    @required LocationsRepository locationsRepository,
  })  : _authRepository = authRepository,
        _locationsRepository = locationsRepository,
        super(LocationsUninitialized()) {
    _authSubscription = _authRepository.user.listen((user) {
      add(LoadLocations(user.id));
    });
  }

  final AuthenticationRepository _authRepository;
  final LocationsRepository _locationsRepository;

  StreamSubscription _authSubscription;
  StreamSubscription _locationsSubscription;

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _locationsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<LocationsState> mapEventToState(LocationEvents event) async* {
    if (event is LoadLocations) {
      yield* _mapLoadPinsToState(event);
    } else if (event is AddLocation) {
      yield* _mapAddPinToState(event);
    } else if (event is UpdateLocation) {
      yield* _mapUpdatePinToState(event);
    } else if (event is RemoveLocation) {
      yield* _mapRemovePinToState(event);
    } else if (event is LocationsUpdated) {
      yield* _mapPinsUpdatedToState(event);
    }
  }

  Stream<LocationsState> _mapLoadPinsToState(LoadLocations event) async* {
    final userId = _authRepository.currentUser.id;
    _locationsSubscription =
        _locationsRepository.locations(userId).listen((pins) {
      add(LocationsUpdated(pins));
    });
  }

  Stream<LocationsState> _mapAddPinToState(AddLocation event) async* {
    final userId = _authRepository.currentUser.id;
    _locationsRepository.addLocation(event.location.copyWith(userId: userId));
  }

  Stream<LocationsState> _mapUpdatePinToState(UpdateLocation event) async* {
    _locationsRepository.updateLocation(event.location);
  }

  Stream<LocationsState> _mapRemovePinToState(RemoveLocation event) async* {
    _locationsRepository.deleteLocation(event.location);
  }

  Stream<LocationsState> _mapPinsUpdatedToState(LocationsUpdated event) async* {
    yield LocationsLoaded(event.locations);
  }
}
