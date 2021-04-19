import 'package:flutter/material.dart';

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
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: const Color(0xFFFFD600),
      ),
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
