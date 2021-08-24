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

    var bloc = BlocProvider.of<CountriesBloc>(context);
    _subscription = bloc.stream.listen((state) {
      if (state is CountriesLoaded) {
        if (state.viewPort != null) {
          _controller.forward();

          if (_countryCode != state.viewPort.code) {
            setState(() => _countryCode = state.viewPort.code);
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
        child: CurrentCountryContainer(
          name: _name,
          code: _countryCode,
        ),
      ),
    );
  }
}

class CurrentCountryContainer extends StatelessWidget {
  CurrentCountryContainer({
    this.name,
    this.code,
    this.textAlign,
  });

  final String name;
  final String code;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.black.withOpacity(.15),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          code.isNotEmpty
              ? SizedBox(
                  width: 26,
                  height: 26,
                  child: CountryAvatar(code),
                )
              : Container(),
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
                name,
                key: ValueKey<String>(name),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: textAlign ?? TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
