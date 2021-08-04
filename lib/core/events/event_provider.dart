part of core.events;

class EventProvider extends StatefulWidget {
  EventProvider({Key key, this.child}) : super(key: key);
  final Widget child;

  static _EventProviderState of(BuildContext context, {bool root = false}) {
    return root
        ? context.findRootAncestorStateOfType<_EventProviderState>()
        : context.findAncestorStateOfType<_EventProviderState>();
  }

  @override
  State createState() => _EventProviderState();
}

class _EventProviderState extends State<EventProvider> {
  final StreamController<Event> _events = StreamController<Event>.broadcast();

  @override
  void dispose() {
    _events.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void dispatch(Event event) {
    _events.sink.add(event);
  }

  Stream<Event> get events => _events.stream;
}
