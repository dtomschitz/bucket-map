part of cubits.login;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthenticationRepository _authRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    //final status = Formz.validate([email]);
    final status = FormzStatus.valid;

    emit(state.copyWith(
      email: email,
      error: status.isInvalid ? 'Die E-Mail ist nicht korrekt' : null,
      emailStatus: status,
    ));
  }

  Future<bool> verifyEmail() async {
    emit(state.copyWith(loading: true));
    final verifiedEmail = await _authRepository.verifyEmail(state.email.value);

    emit(state.copyWith(
      loading: false,
      error: verifiedEmail == null ? 'Ihr Konto wurde nicht gefunden' : null,
    ));

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

  Future<void> logInWithCredentials() async {
    if (!state.passwordStatus.isValidated) return;
    emit(state.copyWith(
      passwordStatus: FormzStatus.submissionInProgress,
      loading: true,
      error: null,
    ));

    try {
      await _authRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(
        passwordStatus: FormzStatus.submissionSuccess,
        loading: false,
        error: null,
      ));
    } on Exception {
      emit(state.copyWith(
        passwordStatus: FormzStatus.submissionFailure,
        error: 'Anmeldung fehlgeschlagen',
        loading: false,
      ));
    }
  }
}
