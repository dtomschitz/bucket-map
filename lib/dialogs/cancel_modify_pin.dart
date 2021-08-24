part of dialogs;

class CancelModifyPinDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.all(16),
      title:
          Text('Möchtest du die Änderungen an diesem Pin wirklich verwerfen?'),
      actions: [
        TextButton(
          child: Text('Nein'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        OutlinedButton(
          child: Text('Ja'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
