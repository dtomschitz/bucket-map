part of core.auth;

class LoginState extends Equatable {
  const LoginState({
    this.email,
    this.password,
  });

  final String email;
  final String password;

  LoginState copyWith({String email, String password}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [email, password];
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());
  final AuthRepository _authRepository;

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  Future<bool> isEmailInUse() {
    return _authRepository.isEmailInUse(state.email);
  }

  Future<bool> logInWithCredentials() async {
    try {
      return await _authRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
    } on Exception {
      return false;
    }
  }
}

class LoginPage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    final authRepository = RepositoryProvider.of<AuthRepository>(context);
    final cubit = LoginCubit(authRepository);

    return BlocProvider<LoginCubit>.value(
      value: cubit,
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(16),
          physics: NeverScrollableScrollPhysics(),
          children: [
            _LogoContainer(),
            _EmailView(),
          ],
        ),
      ),
    );
  }
}

class _LogoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Padding(
            padding: EdgeInsets.all(46),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      height: 64,
                      width: 64,
                      child: Image.asset('logo.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Bucket Map',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailView extends StatefulWidget {
  @override
  State createState() => _EmailViewState();
}

class _EmailViewState extends State<_EmailView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();

        return Form(
          key: _formKey,
          child: Column(
            children: [
              EmailFormField(
                initialValue: state.email,
                onChanged: cubit.updateEmail,
              ),
              SizedBox(height: 16),
              PasswordFormField(
                controller: _passwordController,
                onChanged: cubit.updatePassword,
              ),
              SizedBox(height: 16),
              BottomActions(
                children: [
                  TextButton(
                    child: Text('Konto erstellen'),
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return RegisterPage();
                        }),
                      );
                    },
                  ),
                  OutlinedButton(
                    child: Text('Anmelden'),
                    onPressed: () async {
                      final isFormValid = _formKey.currentState.validate();
                      if (!isFormValid) return;

                      final isEmailInUse = await cubit.isEmailInUse();
                      if (!isEmailInUse) {
                        showSnackbar(context, () => EmailNotInUseSnackBar());
                        return;
                      }

                      cubit.logInWithCredentials();
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
