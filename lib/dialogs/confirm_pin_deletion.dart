import 'package:flutter/material.dart';

class ConfirmPinDeletionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Bist du sicher?'),
      content: Text('Der Pin wird unwiderruflich gelöscht!'),
      actions: [
        TextButton(
          child: Text('Löschen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Abbrechen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
