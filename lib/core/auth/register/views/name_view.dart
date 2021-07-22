class NameView extends StatelessWidget {
  const NameView({this.onNextView});
  
  final Function() onNextView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final isValid = state.firstName.isNotEmpty && state.lastName.isNotEmpty;

        return ListViewContainer(
          title: 'Konto anlegen',
          subtitle: 'Bitte geben Sie ihren Namen ein.',
          children: [
            InputField(
              onChanged: context.read<RegisterCubit>().firstNameChanged,
              keyboardType: TextInputType.name,
              labelText: 'Vorname',
            ),
            SizedBox(height: 16),
            InputField(
              onChanged: context.read<RegisterCubit>().lastNameChanged,
              keyboardType: TextInputType.name,
              labelText: 'Nachname',
            ),
            SizedBox(height: 32),
            BottomActions(
              children: [
                Spacer(),
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