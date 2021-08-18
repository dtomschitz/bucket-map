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

  Future<void> logInWithCredentials() async {
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
  final PageController _pageController = PageController(initialPage: 0);
  static Page page() => MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    final authRepository = RepositoryProvider.of<AuthRepository>(context);
    final cubit = LoginCubit(authRepository);

    return BlocProvider<LoginCubit>.value(
      value: cubit,
      child: Scaffold(
        body: Column(
          children: [
            ClipRect(
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
            Expanded(
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _EmailView(
                      onNextView: () => _jumpToPage(1),
                      onRegister: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return RegisterPage();
                          }),
                        );
                      }),
                  _PasswordView(
                    onPreviouseView: () => _jumpToPage(0),
                    onLogin: () {
                      cubit.logInWithCredentials();
                    },
                  ),
                ],
              ),
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

class _EmailView extends StatefulWidget {
  _EmailView({this.onNextView, this.onRegister});

  final VoidCallback onNextView;
  final VoidCallback onRegister;

  @override
  State createState() => _EmailViewState();
}

class _EmailViewState extends State<_EmailView> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
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
              BottomActions(
                children: [
                  TextButton(
                    child: Text('Konto erstellen'),
                    onPressed: () {
                      widget.onRegister?.call();
                    },
                  ),
                  OutlinedButton(
                    child: Text('Weiter'),
                    onPressed: () async {
                      final isEmailValid = _formKey.currentState.validate();
                      if (!isEmailValid) return;

                      final isEmailInUse = await cubit.isEmailInUse();
                      if (!isEmailInUse) {
                        showSnackbar(context, () => EmailNotInUseSnackBar());
                        return;
                      }

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

class _PasswordView extends StatefulWidget {
  _PasswordView({this.onPreviouseView, this.onLogin});

  final VoidCallback onPreviouseView;
  final VoidCallback onLogin;

  @override
  State createState() => _PasswordViewState();
}

class _PasswordViewState extends State<_PasswordView> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            physics: NeverScrollableScrollPhysics(),
            children: [
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
                validator: Utils.validatePassword,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: cubit.updatePassword,
              ),
              SizedBox(height: 32),
              BottomActions(
                children: [
                  TextButton(
                    child: Text('Zurück'),
                    onPressed: widget.onPreviouseView?.call,
                  ),
                  OutlinedButton(
                    child: Text('Anmelden'),
                    onPressed: widget.onLogin?.call,
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
