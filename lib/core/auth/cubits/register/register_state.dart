part of cubits.register;

enum ConfirmPasswordValidationError { invalid }

class RegisterState extends Equatable {
  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.id,
    this.name,
    this.photo,
    this.planned,
    this.amountCountries,
    this.amountPins,
    this.currentCountry,
    this.countries,
    this.pinIds,
    //this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final String id;
  final String name;
  final String photo;
  final int planned;
  final int amountCountries;
  final int amountPins;
  final String currentCountry;
  final List<String> countries;
  final List<int> pinIds;


  //final ConfirmedPassword confirmedPassword;
  final FormzStatus status;

  @override
  List<Object> get props => [email, password, id, name, photo, planned, amountCountries, amountPins, currentCountry, countries, pinIds, status];

  RegisterState copyWith({
    Email email,
    Password password,
    String id,
    String name,
    String photo,
    int planned,
    int amountCountires,
    int amountPins,
    String currentCountry,
    List<String> countries,
    List<int> pinIds,
    //ConfirmedPassword confirmedPassword,
    FormzStatus status,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      planned: planned ?? this.planned,
      amountCountries: amountCountries ?? this.amountCountries,
      amountPins: amountPins ?? this.amountPins,
      currentCountry: currentCountry ?? this.currentCountry,
      countries: countries ?? this.countries,
      pinIds: pinIds ?? this.pinIds,
      //confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
    );
  }
}
