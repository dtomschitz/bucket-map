part of core.auth;

class RegisterState extends Equatable {
  const RegisterState({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.country,
  });

  final String email;
  final String password;

  final String firstName;
  final String lastName;

  final Country country;

  RegisterState copyWith({
    String email,
    String password,
    String firstName,
    String lastName,
    Country country,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      country: country ?? this.country,
    );
  }

  @override
  List<Object> get props => [email, password, firstName, lastName, country];
}

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepository) : super(const RegisterState());

  final AuthRepository _authRepository;

  void updateFirstName(String firstName) {
    emit(state.copyWith(firstName: firstName));
  }

  void updateLastName(String lastName) {
    emit(state.copyWith(lastName: lastName));
  }

  void updateCountry(Country country) {
    emit(state.copyWith(country: country));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  Future<bool> isEmailInUse() async {
    return _authRepository.isEmailInUse(state.email);
  }

  Future<bool> registerUser() async {
    try {
      await _authRepository.signUp(
        email: state.email,
        password: state.password,
        firstName: state.firstName,
        lastName: state.lastName,
        country: state.country,
      );

      return true;
    } on Exception {
      return false;
    }
  }
}

class RegisterPage extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final authRepository = RepositoryProvider.of<AuthRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konto anlegen'),
      ),
      body: BlocProvider<RegisterCubit>(
        create: (context) => RegisterCubit(authRepository),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _DetailView(
              onNextView: () => _jumpToPage(1),
              onLogin: () => Navigator.pop(context),
            ),
            _LoginDetailsView(
              onPreviouseView: () => _jumpToPage(0),
              onNextView: () => _jumpToPage(2),
            ),
            _SummaryView(
              onPreviouseView: () => _jumpToPage(1),
              onRegister: () {
                context.read<RegisterCubit>().registerUser();
              },
            ),
          ],
        ),
      ),
    );
  }

  _jumpToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }
}

class _DetailView extends StatefulWidget {
  _DetailView({this.onNextView, this.onLogin});

  final VoidCallback onNextView;
  final VoidCallback onLogin;

  @override
  State createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView> {
  final _countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            physics: NeverScrollableScrollPhysics(),
            children: [
              TextFormField(
                initialValue: state.firstName,
                keyboardType: TextInputType.name,
                validator: (value) => Utils.validateString(
                  value,
                  message: 'Bitte geben Sie einen Vornamen ein',
                ),
                decoration: InputDecoration(labelText: 'Vorname'),
                onChanged: cubit.updateFirstName,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: state.firstName,
                keyboardType: TextInputType.name,
                validator: (value) => Utils.validateString(
                  value,
                  message: 'Bitte geben Sie einen Nachname ein',
                ),
                decoration: InputDecoration(labelText: 'Nachname'),
                onChanged: cubit.updateLastName,
              ),
              SizedBox(height: 16),
              TextFormField(
                //initialValue: state?.country?.name,
                controller: _countryController,
                readOnly: true,
                validator: (value) => Utils.validateString(
                  value,
                  message: 'Bitte wählen Sie ihr Heimatland',
                ),
                decoration: InputDecoration(labelText: 'Heimatland'),
                onTap: () async {
                  final country = await CountrySearch.show(context);
                  if (country != null) {
                    cubit.updateCountry(country);
                    _countryController.text = country.name;
                  }
                },
              ),
              SizedBox(height: 32),
              BottomActions(
                children: [
                  TextButton(
                    child: Text('Zurück'),
                    onPressed: widget.onLogin?.call,
                  ),
                  OutlinedButton(
                    child: Text('Weiter'),
                    onPressed: () {
                      final isFormValid = _formKey.currentState.validate();
                      if (!isFormValid) return;

                      widget.onNextView?.call();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoginDetailsView extends StatelessWidget {
  _LoginDetailsView({this.onPreviouseView, this.onNextView});

  final VoidCallback onPreviouseView;
  final VoidCallback onNextView;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        final authRepository = RepositoryProvider.of<AuthRepository>(context);

        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            physics: NeverScrollableScrollPhysics(),
            children: [
              TextFormField(
                initialValue: state.email,
                keyboardType: TextInputType.emailAddress,
                validator: Utils.validateEmail,
                decoration: InputDecoration(labelText: 'E-Mail'),
                onChanged: cubit.updateEmail,
              ),
              SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                validator: Utils.validatePassword,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Passwort'),
                onChanged: cubit.updatePassword,
              ),
              SizedBox(height: 32),
              BottomActions(
                children: [
                  TextButton(
                    child: Text('Zurück'),
                    onPressed: onPreviouseView?.call,
                  ),
                  OutlinedButton(
                    child: Text('Weiter'),
                    onPressed: () {
                      final isFormValid = _formKey.currentState.validate();
                      if (!isFormValid) return;

                      onNextView?.call();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryView extends StatelessWidget {
  _SummaryView({this.onPreviouseView, this.onRegister});

  final VoidCallback onPreviouseView;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return ListViewContainer(
          title: 'Zusammenfassung',
          children: [
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('${state.firstName} ${state.lastName}'),
            ),
            ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text(state.email ?? ''),
            ),
            ListTile(
              leading: Icon(Icons.my_location_outlined),
              title: Text(state.country.name),
            ),
            SizedBox(height: 32),
            BottomActions(
              children: [
                TextButton(
                  child: Text('Zurück'),
                  onPressed: onPreviouseView?.call,
                ),
                OutlinedButton(
                  child: Text('Konto anlegen'),
                  onPressed: onRegister?.call,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
