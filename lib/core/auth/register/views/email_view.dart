class EmailView extends StatelessWidget {
  const EmailView({this.onNextView, this.onPreviouseView});

  final Function() onNextView;
  final Function() onPreviouseView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final isValid = state.emailStatus == FormzStatus.valid;

        return ListViewContainer(
          title: 'Konto anlegen',
          subtitle: 'Bitte geben Sie ihre E-Mail ein.',
          children: [
            InputField(
              onChanged: context.read<RegisterCubit>().emailChanged,
              keyboardType: TextInputType.emailAddress,
              labelText: 'E-Mail',
              errorText: state.error,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text('Zurück'),
                    onPressed: onPreviouseView?.call,
                  ),
                  ElevatedButton(
                    child: Text('Weiter'),
                    onPressed: () async {
                      final exists = await context
                          .read<RegisterCubit>()
                          .checkIfEmailExists();

                      if (exists) return;
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