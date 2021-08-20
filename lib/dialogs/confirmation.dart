part of dialogs;

class ConfirmationDialog extends StatelessWidget {
  ConfirmationDialog({
    this.title,
    this.content,
    this.okText,
    this.cancelText,
  });

  final Text title;
  final Text content;
  final Text cancelText;
  final Text okText;

  static Future<bool> show(
    BuildContext context, {
    Text title,
    Text content,
    Text cancelText,
    Text okText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        title: title,
        content: content,
        cancelText: cancelText,
        okText: okText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          child: cancelText,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: okText,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
