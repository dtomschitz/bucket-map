part of widgets.auth;

class FormInputField extends StatelessWidget {
  const FormInputField({
    this.key,
    this.onChanged,
    this.keyboardType,
    this.labelText,
    this.errorText,
    this.obscureText = false
  });

  final Key key;
  final Function onChanged;
  final String labelText;
  final String errorText;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        labelText: labelText,
        errorText: errorText
      ),
    );
  }
}
