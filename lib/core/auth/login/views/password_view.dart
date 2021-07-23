part of auth.login.views;

class PasswordView extends StatelessWidget {
  const PasswordView({this.onPreviouseView});
  final Function() onPreviouseView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final String labelText = 'Password';

        return ListViewContainer(
          title: 'Willkommen',
          subtitle: state.email.value,
          children: [
            InputField(
              obscureText: true,
              onChanged: context.read<LoginCubit>().passwordChanged,
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
                    child: Text(
                      'Zurück',
                    ),
                    onPressed: onPreviouseView?.call,
                  ),
                  ElevatedButton(
                    child: Text('Anmelden'),
                    onPressed: () {
                      context.read<LoginCubit>().logInWithCredentials();
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
