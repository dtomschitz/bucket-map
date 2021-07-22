part of cubits.register;

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepository) : super(const RegisterState());

  final AuthenticationRepository _authRepository;

  void firstNameChanged(String firstName) {
    emit(state.copyWith(firstName: firstName));
  }

  void lastNameChanged(String lastName) {
    emit(state.copyWith(lastName: lastName));
  }

  void countryChanged(Country country) {
    emit(state.copyWith(country: country));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    //final status = Formz.validate([email]);
    final status = FormzStatus.valid;

    emit(state.copyWith(
      email: email,
      emailStatus: status,
      error: status.isInvalid ? 'Die E-Mail ist nicht korrekt' : null,
    ));
  }

  Future<bool> checkIfEmailExists() async {
    emit(state.copyWith(loading: true));
    final verifiedEmail = await _authRepository.verifyEmail(state.email.value);

    emit(
      state.copyWith(
        loading: false,
        error: verifiedEmail != null
            ? 'Diese E-Mail wird bereits verwendet'
            : null,
      ),
    );

    return verifiedEmail != null;
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      passwordStatus: Formz.validate([password]),
      error: null,
    ));
  }

  Future<bool> registerUser() async {
    emit(state.copyWith(
      passwordStatus: FormzStatus.submissionInProgress,
      loading: true,
      error: null,
    ));

    try {
      await _authRepository.signUp(
        email: state.email.value,
        password: state.password.value,
        firstName: state.firstName,
        lastName: state.lastName,
        country: state.country,
      );

      emit(state.copyWith(
        passwordStatus: FormzStatus.submissionSuccess,
        loading: false,
        error: null,
      ));

      return true;
    } on Exception {
      emit(state.copyWith(
        passwordStatus: FormzStatus.submissionFailure,
        loading: false,
        error: null,
      ));

      return false;
    }
  }
}
