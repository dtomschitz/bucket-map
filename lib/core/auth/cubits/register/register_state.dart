part of cubits.register;

enum ConfirmPasswordValidationError { invalid }

class RegisterState extends Equatable {
  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.id,
    this.name,
    this.photo,
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final String id;
  final String name;
  final String photo;

  final FormzStatus status;

  @override
  List<Object> get props => [email, password, id, name, photo, status];

  RegisterState copyWith({
    Email email,
    Password password,
    String id,
    String name,
    String photo,
    FormzStatus status,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      status: status ?? this.status,
    );
  }
}
