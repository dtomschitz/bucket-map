part of widgets.auth;

class FormButton extends StatelessWidget {
  const FormButton({
    this.key,
    this.onPressed,
    this.text,
  });

  final Key key;
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key,
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
