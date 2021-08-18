part of dialogs;

class DeletePinDialog extends StatelessWidget {
  DeletePinDialog({this.pin});
  final Pin pin;

  static Future<bool> show(BuildContext context, Pin pin) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => DeletePinDialog(pin: pin),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pin löschen?'),
      content: Text('Dieser Vorgang kann nicht rückgänig gemacht werden'),
      actions: [
        TextButton(
          child: Text('Abbrechen'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text('Löschen'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
