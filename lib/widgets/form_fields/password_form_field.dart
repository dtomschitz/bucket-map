part of widgets;

class PasswordFormField extends StatelessWidget {
  PasswordFormField({
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
      validator: Utils.validatePassword,
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
      onChanged: onChanged?.call,
    );
  }
}
