part of widgets;

class EmailFormField extends StatelessWidget {
  EmailFormField({
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
      keyboardType: TextInputType.emailAddress,
      validator: Utils.validateEmail,
      decoration: InputDecoration(labelText: 'E-Mail'),
      onChanged: onChanged?.call,
    );
  }
}
