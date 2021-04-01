import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ElevatedIconButton extends StatelessWidget {
  final Widget icon;
  final Function onPressed;

  const ElevatedIconButton({this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: this.icon,
        color: Colors.black,
        onPressed: this.onPressed,
      ),
    );
  }
}
