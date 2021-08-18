part of screens;

class ModifyPinScreen extends StatefulWidget {
  ModifyPinScreen({this.pin});
  final Pin pin;

  static show(BuildContext context, Pin pin) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return ModifyPinScreen(pin: pin);
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State createState() => _ModifyPinScreenState();
}

class _ModifyPinScreenState extends State<ModifyPinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  Country _country;

  @override
  initState() {
    super.initState();
    _loadInitialCountry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Pin bearbeiten'),
            pinned: true,
          ),
          Form(
            key: _formKey,
            child: SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _nameController..text = widget.pin.name,
                      decoration: InputDecoration(
                        hintText: "Neuer Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte gib einen Namen ein';
                        }

                        return null;
                      },
                    ),
                  ),
                  Column(
                    children: [
                      CountrySelect(
                        country: _country,
                        onChange: (country) {
                          setState(() => _country = country);
                        },
                      ),
                      PinPreviewCard(
                        coordinates: LatLng(widget.pin.latitude, widget.pin.longitude),
                        height: 346,
                        elevation: 0,
                        padding: EdgeInsets.all(16),
                      ),
                      LocationListTile(
                        title: Text('Aktuelle Koordinaten'),
                        coordinates: LatLng(widget.pin.latitude, widget.pin.longitude),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Speichern'),
        onPressed: () {
          final isFormValid = _formKey.currentState.validate();
          final isCountrySelected = _country != null;

          if (isFormValid && isCountrySelected) {
            final pin = Pin(
              id: widget.pin.id,
              userId: widget.pin.userId,
              name: _nameController.text,
              country: _country.code,
              latitude: widget.pin.latitude,
              longitude: widget.pin.longitude,
            );

            
            BlocProvider.of<PinsBloc>(context).add(UpdatePin(pin: pin));
            var state = BlocProvider.of<PinsBloc>(context).state;
              if (state is PinsLoaded) {
                BlocProvider.of<PinsBloc>(context).add(PinsUpdated(state.pins));
              }

            
            // BlocProvider.of<PinsBloc>(context).add(LoadPins(widget.pin.userId));
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  _loadInitialCountry() async {
    var state = BlocProvider.of<CountriesBloc>(context).state;
    if (state is CountriesLoaded && _country == null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.pin.latitude,
        widget.pin.longitude,
      );

      final code = placemarks.first?.isoCountryCode;
      final country = state.countries.firstWhere(
        (country) => country.code == code,
      );

      if (country != null) {
        setState(() => _country = country);
      }
    }
  }
}
