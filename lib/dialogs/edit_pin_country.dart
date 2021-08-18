part of dialogs;

class EditPinCountryDialog extends StatelessWidget {
  EditPinCountryDialog({this.pin});
  final Pin pin;

  static Future<bool> show(BuildContext context, Pin pin) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => EditPinCountryDialog(pin: pin),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Land ändern'),
      actions: [
        TextButton(
          child: Text('Abbrechen'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text('Speichern'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
