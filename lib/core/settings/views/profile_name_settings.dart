part of core.settings;

class ProfileNameSettingsView extends StatefulWidget {
  ProfileNameSettingsView({this.profile});

  final Profile profile;

  @override
  State createState() => _ProfileNameSettingsViewState();
}

class _ProfileNameSettingsViewState extends State<ProfileNameSettingsView> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _hasChanges = false;

  @override
  initState() {
    super.initState();

    _firstNameController.text = widget.profile.firstName;
    _lastNameController.text = widget.profile.lastName;

    _firstNameController.addListener(_changeListener);
    _lastNameController.addListener(_changeListener);
  }

  @override
  dispose() {
    _firstNameController.removeListener(_changeListener);
    _lastNameController.removeListener(_changeListener);

    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Scaffold(
            appBar: AppBar(
              leading: CancelConfirmationButton(
                hasChanges: _hasChanges,
              ),
              title: Text('Name bearbeiten'),
            ),
            body: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(16),
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        FirstNameFormField(controller: _firstNameController),
                        SizedBox(height: 16),
                        LastNameNameFormField(controller: _lastNameController),
                      ],
                    ),
                  );
                }

                return TopCircularProgressIndicator();
              },
            ),
            floatingActionButton: _hasChanges
                ? SaveButton(
                    formKey: _formKey,
                    onValidated: (isValid) {
                      if (isValid) {
                        var profile = state.profile.copyWith(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                        );

                        var event = UpdateProfile(profile: profile);
                        BlocProvider.of<ProfileBloc>(context).add(event);
                        Navigator.pop(context);
                      }
                    },
                  )
                : null,
          );
        }

        return Scaffold(appBar: AppBar(title: Text('Name bearbeiten')));
      },
    );
  }

  _changeListener() {
    final hasChanges = _firstNameController.text != widget.profile.firstName ||
        _lastNameController.text != widget.profile.lastName;

    setState(() => _hasChanges = hasChanges);
  }
}
