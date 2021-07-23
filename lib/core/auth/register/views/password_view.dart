part of auth.register.views;

class PasswortView extends StatelessWidget {
  const PasswortView({this.onNextView, this.onPreviouseView});

  final Function() onNextView;
  final Function() onPreviouseView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final isValid = state.passwordStatus == FormzStatus.valid;

        return ListViewContainer(
          title: 'Passwort wählen',
          subtitle:
              'Erstellen Sie ein starkes Passwort aus Buchstaben, Zahlen und Sonderzeichen.',
          children: [
            InputField(
              onChanged: context.read<RegisterCubit>().passwordChanged,
              obscureText: true,
              labelText: 'Password',
            ),
            SizedBox(height: 32),
            BottomActions(
              children: [
                TextButton(
                  child: Text('Zurück'),
                  onPressed: onPreviouseView?.call,
                ),
                ElevatedButton(
                  child: Text('Weiter'),
                  onPressed: isValid ? onNextView?.call : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
