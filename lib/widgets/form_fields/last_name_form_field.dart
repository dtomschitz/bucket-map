part of widgets;

class LastNameNameFormField extends StatelessWidget {
  LastNameNameFormField({this.controller, this.onLastNameChange});

  final TextEditingController controller;
  final Function(String firstName) onLastNameChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      validator: (value) => Utils.validateString(
        value,
        message: 'Bitte geben Sie einen Nachname ein',
      ),
      decoration: InputDecoration(labelText: 'Nachname'),
      onChanged: onLastNameChange?.call,
    );
  }
}
