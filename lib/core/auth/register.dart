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
              onNextView: () => _jumpToPage(context, page: 1),
              onLogin: () => Navigator.pop(context),
            ),
            _LoginDetailsView(
              onPreviouseView: () => _jumpToPage(context, page: 0),
              onNextView: () => _jumpToPage(context, page: 2),
            ),
            _SummaryView(
              onPreviouseView: () => _jumpToPage(context, page: 1),
            ),
          ],
        ),
      ),
    );
  }

  _jumpToPage(BuildContext context, {int page}) {
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
              FirstNameFormField(
                initialValue: state.firstName,
                onChanged: cubit.updateFirstName,
              ),
              SizedBox(height: 16),
              LastNameNameFormField(
                initialValue: state.firstName,
                onChanged: cubit.updateLastName,
              ),
              SizedBox(height: 16),
              CountryFormField(
                controller: _countryController,
                onCountryChange: cubit.updateCountry,
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
    final cubit = context.read<RegisterCubit>();

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            physics: NeverScrollableScrollPhysics(),
            children: [
              EmailFormField(
                initialValue: state.email,
                onChanged: cubit.updateEmail,
              ),
              SizedBox(height: 16),
              PasswordFormField(onChanged: cubit.updatePassword),
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
  _SummaryView({this.onPreviouseView});
  final VoidCallback onPreviouseView;

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
                  onPressed: () async {
                    await context.read<RegisterCubit>().registerUser();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
