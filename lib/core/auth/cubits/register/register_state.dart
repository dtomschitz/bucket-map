part of cubits.register;

enum ConfirmPasswordValidationError { invalid }

class RegisterState extends Equatable {
  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name,
    this.age,
    this.originCountry,
    //this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final String name;
  final int age;
  final String originCountry;
  //final ConfirmedPassword confirmedPassword;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, name, age, originCountry, status];

  RegisterState copyWith({
    Email email,
    Password password,
    String name,
    int age,
    String originCountry,
    //ConfirmedPassword confirmedPassword,
    FormzStatus status,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      age: age ?? this.age,
      originCountry: originCountry ?? this.originCountry,
      //confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
    );
  }
}
