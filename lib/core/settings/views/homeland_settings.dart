part of core.settings;

class HomelandSettingsView extends StatefulWidget {
  HomelandSettingsView({this.profile, this.country});

  final Profile profile;
  final Country country;

  @override
  State createState() => _HomelandSettingsViewState();
}

class _HomelandSettingsViewState extends State<HomelandSettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();

  bool _hasChanges = false;

  @override
  initState() {
    super.initState();

    _countryController.text = widget.profile.country;
    _countryController.addListener(_changeListener);
  }

  @override
  dispose() {
    _countryController.removeListener(_changeListener);
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CancelConfirmationButton(
          hasChanges: _hasChanges,
        ),
        title: Text('Heimatland bearbeiten'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          physics: NeverScrollableScrollPhysics(),
          children: [
            CountryInputField(
              controller: _countryController,
              initialCountry: widget.country,
            ),
          ],
        ),
      ),
      floatingActionButton: _hasChanges
          ? SaveButton(
              formKey: _formKey,
              onValidated: (isValid) {
                if (isValid) {
                  var event = UpdateProfile(
                    profile: widget.profile.copyWith(
                      country: _countryController.text,
                    ),
                  );

                  BlocProvider.of<ProfileBloc>(context).add(event);
                  Navigator.pop(context);
                }
              },
            )
          : null,
    );
  }

  _changeListener() {
    final hasChanges = _countryController.text != widget.profile.country;
    setState(() => _hasChanges = hasChanges);
  }
}
