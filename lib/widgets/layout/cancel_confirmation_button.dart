part of widgets;

class CancelConfirmationButton extends StatelessWidget {
  CancelConfirmationButton({
    this.hasChanges,
    Icon icon,
    Widget dialog,
  })  : this.icon = icon ?? Icon(Icons.close_outlined),
        this.dialog = dialog ?? DiscardChangesDialog();

  final bool hasChanges;

  final Icon icon;
  final Widget dialog;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: () async {
        FocusScope.of(context).unfocus();

        if (hasChanges) {
          final discardChanges = await showAppDialog<bool>(
                context,
                dialog: dialog,
              ) ??
              false;
          if (!discardChanges) return;
        }

        Navigator.pop(context);
      },
    );
  }
}
