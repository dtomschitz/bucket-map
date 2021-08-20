part of screens;

class CountryMap extends StatefulWidget {
  CountryMap({this.country});

  final Country country;

  @override
  State createState() => _CountryMapState();
}

class _CountryMapState extends State<CountryMap> {
  final MapController _mapController = MapController();
  StreamSubscription _pinsSubscription;

  @override
  void dispose() {
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
            final pins = state.getPinsByCountry(widget.country);

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
                CountryPinsList(
                  country: widget.country,
                  pins: pins,
                  onPinChanged: (pin) {
                    _mapController.animateCameraToPin(pin);
                  },
                ),
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
      _addPins(state);
    }

    _pinsSubscription = bloc.stream.listen((state) {
      if (state is PinsLoaded) {
        _addPins(state);
      }
    });
  }

  _addPins(PinsLoaded state) {
    _mapController.addPins(state.getPinsByCountry(widget.country));
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
