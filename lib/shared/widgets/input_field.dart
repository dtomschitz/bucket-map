part of shared.widgets;

class InputField extends StatelessWidget {
  const InputField({
    this.key,
    this.initialValue,
    this.controller,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.labelText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    this.readOnly = false,
    this.focusNode,
    this.enableInteractiveSelection = true,
  });

  final Key key;
  final String initialValue;
  final TextEditingController controller;
  final FocusNode focusNode;

  final Function onTap;
  final Function onChanged;

  final String labelText;
  final String errorText;
  final TextInputType keyboardType;

  final bool readOnly;
  final bool obscureText;
  final bool autofocus;
  final bool enableInteractiveSelection;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      readOnly: readOnly,
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofocus: autofocus,
      enableInteractiveSelection: enableInteractiveSelection,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText,
      ),
    );
  }
}
