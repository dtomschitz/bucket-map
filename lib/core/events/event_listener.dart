part of core.events;

class EventListener extends StatefulWidget {
  const EventListener({
    Key key,
    this.onEvent,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final Function(Event event) onEvent;

  @override
  State createState() => _EventListenerState();
}

class _EventListenerState extends State<EventListener> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = EventProvider.of(context).events.listen((event) {
      widget.onEvent.call(event);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
