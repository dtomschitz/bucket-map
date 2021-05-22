part of blocs.countries;

class PinsBloc extends Bloc<PinsEvents, PinsState> {
  PinsBloc() : super(PinsUninitialized());
  final databaseReference = FirebaseFirestore.instance;

  @override
  Stream<PinsState> mapEventToState(PinsEvents event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
