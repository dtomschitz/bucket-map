part of dialogs;

class DiscardChangesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.all(16),
      title: Text('Möchtest du die Änderungen wirklich verwerfen?'),
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
