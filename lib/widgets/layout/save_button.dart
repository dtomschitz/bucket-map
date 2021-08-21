part of widgets;

class SaveButton extends StatelessWidget {
  SaveButton({this.formKey, this.onValidated});

  final GlobalKey<FormState> formKey;
  final Function(bool isValid) onValidated;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text('Speichern'),
      onPressed: () {
        final isFormValid = formKey.currentState.validate();
        onValidated?.call(isFormValid);
      },
    );
  }
}
