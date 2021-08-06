part of widgets;

class CurrentCountry extends StatefulWidget {
  @override
  State createState() => _CurrentCountryState();
}

class _CurrentCountryState extends State<CurrentCountry>
    with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _iconController;

  Animation<double> _animation;
  Animation<double> _iconAnimation;

  StreamSubscription _subscription;

  String _name = '';
  String _countryCode = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeIn,
    );

    var bloc = BlocProvider.of<CountriesBloc>(context);
    _subscription = bloc.stream.listen((state) {
      if (state is CountriesLoaded) {
        if (state.viewPort != null) {
          _controller.forward();

          if (_countryCode != state.viewPort.countryCode) {
            setState(() => _countryCode = state.viewPort.countryCode);
          }

          if (_name != state.viewPort.name) {
            setState(() => _name = state.viewPort.name);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FadeScaleTransition(
        animation: _animation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.grey.withOpacity(.32),
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: CountryAvatar('de'),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return FadeScaleTransition(
                      child: child,
                      animation: animation,
                    );
                  },
                  child: Text(
                    _name,
                    key: ValueKey<String>(_name),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
