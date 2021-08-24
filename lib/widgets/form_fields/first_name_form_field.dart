part of widgets;

class FirstNameFormField extends StatelessWidget {
  FirstNameFormField({
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
      initialValue: initialValue,
      keyboardType: TextInputType.name,
      validator: (value) => Utils.validateString(
        value,
        message: 'Bitte geben Sie einen Vornamen ein',
      ),
      decoration: InputDecoration(labelText: 'Vorname'),
      onChanged: onChanged?.call,
    );
  }
}
