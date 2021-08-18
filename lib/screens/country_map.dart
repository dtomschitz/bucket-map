part of screens;

class CountryMap extends StatefulWidget {
  CountryMap({this.country});

  final Country country;

  @override
  State createState() => _CountryMapState();
}

class _CountryMapState extends State<CountryMap> {
  final MapController _mapController = MapController();
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  final _pinsStreamController = StreamController<List<Pin>>()..add([]);
  StreamSubscription _pinsSubscription;

  Stream<List<Pin>> get _pins => _pinsStreamController.stream;
  Sink<List<Pin>> get _pinsSink => _pinsStreamController.sink;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pinsStreamController?.close();
    _pinsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _CountryMapAppBar(
        country: widget.country,
        onOpenInfo: () => UnlockedCountryBottomSheet.show(
          context,
          widget.country,
        ),
        onClose: () => Navigator.pop(context),
      ),
      body: BlocBuilder<PinsBloc, PinsState>(
        builder: (context, state) {
          if (state is PinsLoaded) {
            return Stack(
              children: [
                Map(
                  controller: _mapController,
                  disableUserLocation: true,
                  onMapCreated: _onMapCreated,
                  onStyleLoaded: _initPinsListener,
                  onMapClick: (point, coordinates) {
                    CreatePinScreen.show(context, coordinates);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      child: StreamBuilder<List<Pin>>(
                        stream: _pins,
                        builder: (context, snapshot) {
                          final pins = snapshot.data ?? [];

                          return PageView.builder(
                            controller: _pageController,
                            itemCount: pins.length,
                            onPageChanged: (index) async {
                              var pin = pins[index];
                              await _mapController.animateCameraToPin(pin);
                            },
                            itemBuilder: (context, index) {
                              return LocationCard(pins[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
          }

          return TopCircularProgressIndicator();
        },
      ),
    );
  }

  _onMapCreated() async {
    await _mapController.setUnlockedCountries([
      widget.country.code,
    ]);

    Future.delayed(const Duration(milliseconds: 250), () async {
      await _mapController.animateCameraToCountry(
        widget.country,
      );
    });
  }

  _initPinsListener() {
    var bloc = BlocProvider.of<PinsBloc>(context);
    var state = bloc.state;

    if (state is PinsLoaded) {
      _pinsSink.add(state.getPinsByCountry(widget.country));
      //_mapController.addPins(_filterPins(state));
    }

    _pinsSubscription = bloc.stream.listen((state) {
      if (state is PinsLoaded) {
        _pinsSink.add(state.getPinsByCountry(widget.country));
      }
    });
  }
}

class _CountryMapAppBar extends StatelessWidget with PreferredSizeWidget {
  _CountryMapAppBar({
    this.country,
    this.onClose,
    this.onOpenInfo,
  });

  final Country country;
  final VoidCallback onClose;
  final VoidCallback onOpenInfo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),
          AppBarIconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: onClose?.call,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CurrentCountryContainer(
              name: country.name,
              code: country.code,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(width: 8),
          AppBarIconButton(
            icon: Icon(Icons.info_outline),
            onPressed: onOpenInfo?.call,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
