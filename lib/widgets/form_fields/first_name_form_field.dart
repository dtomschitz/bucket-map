part of widgets;

class FirstNameFormField extends StatelessWidget {
  FirstNameFormField({this.controller, this.onFirstNameChange});

  final TextEditingController controller;
  final Function(String firstName) onFirstNameChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      validator: (value) => Utils.validateString(
        value,
        message: 'Bitte geben Sie einen Vornamen ein',
      ),
      decoration: InputDecoration(labelText: 'Vorname'),
      onChanged: onFirstNameChange?.call,
    );
  }
}
