part of auth.login.views;

class EmailView extends StatelessWidget {
  const EmailView({this.onNextView, this.onRegister});

  final Function() onNextView;
  final Function() onRegister;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final String labelText = 'E-Mail';
        final isEmailValid = state.emailStatus == FormzStatus.valid;

        return ListViewContainer(
          title: 'Anmeldung',
          subtitle: 'Melde dich mit deinem Konto an.',
          children: [
            InputField(
              onChanged: context.read<LoginCubit>().emailChanged,
              keyboardType: TextInputType.emailAddress,
              labelText: labelText,
              errorText: state.error,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text('Konto erstellen'),
                    onPressed: () {
                      onRegister?.call();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Weiter'),
                    onPressed: !isEmailValid
                        ? null
                        : () async {
                            final result =
                                await context.read<LoginCubit>().verifyEmail();
                            if (!result) return;

                            onNextView?.call();
                          },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
