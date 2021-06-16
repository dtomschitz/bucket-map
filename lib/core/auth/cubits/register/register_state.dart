part of cubits.register;

enum ConfirmPasswordValidationError { invalid }

class RegisterState extends Equatable {
  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.firstName = '',
    this.lastName = '',
    this.country,
    this.emailStatus,
    this.passwordStatus,
    this.error,
    this.loading = false,
  });

  final Email email;
  final Password password;
  final String firstName;
  final String lastName;
  final Country country;

  final String error;
  final bool loading;

  final FormzStatus emailStatus;
  final FormzStatus passwordStatus;

  @override
  List<Object> get props => [
        email,
        password,
        firstName,
        lastName,
        country,
        error,
        loading,
        emailStatus,
        passwordStatus,
      ];

  RegisterState copyWith({
    Email email,
    Password password,
    String firstName,
    String lastName,
    Country country,
    FormzStatus emailStatus,
    FormzStatus passwordStatus,
    String error,
    bool loading,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      country: country ?? this.country,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
