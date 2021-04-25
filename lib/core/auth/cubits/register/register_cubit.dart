part of cubits.register;

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authenticationRepository) : super(const RegisterState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
        //state.confirmedPassword,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    /*final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );*/
    emit(state.copyWith(
      password: password,
      //confirmedPassword: confirmedPassword,
      status: Formz.validate([
        state.email,
        password,
        //state.confirmedPassword,
      ]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    /*final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );*/
    emit(state.copyWith(
      //confirmedPassword: confirmedPassword,
      status: Formz.validate([
        state.email,
        state.password,
        //confirmedPassword,
      ]),
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}