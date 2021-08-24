part of widgets;

class LastNameNameFormField extends StatelessWidget {
  LastNameNameFormField({
    this.controller,
    this.initialValue,
    this.onChanged,
  });

  final TextEditingController controller;
  final String initialValue;

  final Function(String firstName) onChanged;

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
      onChanged: onChanged?.call,
    );
  }
}
