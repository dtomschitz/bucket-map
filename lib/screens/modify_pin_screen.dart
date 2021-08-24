part of screens;

class ModifyPinScreen extends StatefulWidget {
  ModifyPinScreen({this.pin, this.country});

  final Pin pin;
  final Country country;

  static show(BuildContext context, {Pin pin, Country country}) {
    return Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return ModifyPinScreen(pin: pin, country: country);
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
  final _countryController = TextEditingController();

  bool _hasChanges = false;

  @override
  initState() {
    super.initState();
    _nameController.text = widget.pin.name;
    _countryController.text = widget.pin.country;
    _nameController.addListener(_changeListener);
    _countryController.addListener(_changeListener);
  }

  @override
  dispose() {
    _nameController.removeListener(_changeListener);
    _countryController.removeListener(_changeListener);
    _nameController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_outlined),
          onPressed: () async {
            FocusScope.of(context).unfocus();

            if (_hasChanges) {
              final discardChanges = await showAppDialog<bool>(
                context,
                dialog: CancelModifyPinDialog(),
              );

              if (!discardChanges) return;
            }

            Navigator.pop(context);
          },
        ),
        title: Text('Pin bearbeiten'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          physics: NeverScrollableScrollPhysics(),
          children: [
            TextFormField(
              controller: _nameController,
              validator: (value) => Utils.validateString(
                value,
                message: 'Bitte gib einen Namen ein',
              ),
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Neuer Name',
              ),
            ),
            SizedBox(height: 16),
            CountryInputField(
              initialCountry: widget.country,
              controller: _countryController,
              onCountryChanged: (country) {
                _countryController.text = country.code;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _hasChanges
          ? SaveButton(
              formKey: _formKey,
              onValidated: (isValid) {
                if (isValid) {
                  final pin = widget.pin.copyWith(
                    name: _nameController.text,
                    country: _countryController.text,
                  );

                  BlocProvider.of<PinsBloc>(context).add(UpdatePin(pin: pin));
                  Navigator.pop(context);
                }
              },
            )
          : null,
    );
  }

  _changeListener() {
    final hasChanges = _nameController.text != widget.pin.name ||
        _countryController.text != widget.pin.country;
    setState(() => _hasChanges = hasChanges);
  }
}
