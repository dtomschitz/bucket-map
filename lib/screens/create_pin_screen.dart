part of screens;

class CreatePinScreen extends StatefulWidget {
  CreatePinScreen({this.coordinates});
  final LatLng coordinates;

  static show(BuildContext context, LatLng coordinates) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return CreatePinScreen(coordinates: coordinates);
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
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
    final latitude = widget.coordinates.latitude;
    final longitude = widget.coordinates.longitude;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Pin erstellen'),
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Neuer Pin',
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
                        coordinates: widget.coordinates,
                        height: 346,
                        elevation: 0,
                        padding: EdgeInsets.all(16),
                      ),
                      LocationListTile(
                        title: Text('Aktuelle Koordinaten'),
                        coordinates: widget.coordinates,
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
              name: _nameController.text,
              country: _country.code,
              latitude: widget.coordinates.latitude,
              longitude: widget.coordinates.longitude,
            );

            BlocProvider.of<PinsBloc>(context).add(AddPin(pin: pin));
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }

  _loadInitialCountry() async {
    var state = BlocProvider.of<CountriesBloc>(context).state;
    if (state is CountriesLoaded && _country == null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.coordinates.latitude,
        widget.coordinates.longitude,
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
