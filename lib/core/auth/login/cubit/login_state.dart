part of cubits.login;

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.emailStatus = FormzStatus.pure,
    this.passwordStatus = FormzStatus.pure,
    this.error,
    this.loading = false,
  });

  final Email email;
  final Password password;
  final FormzStatus emailStatus;
  final FormzStatus passwordStatus;
  final String error;
  final bool loading;

  bool get isEmailValid => emailStatus == FormzStatus.valid;
  bool get isPasswordValid => passwordStatus == FormzStatus.valid;

  @override
  List<Object> get props => [
        email,
        password,
        emailStatus,
        passwordStatus,
        loading,
        error,
      ];

  LoginState copyWith({
    Email email,
    Password password,
    FormzStatus emailStatus,
    FormzStatus passwordStatus,
    String error,
    bool loading,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
