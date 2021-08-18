part of core.snack_bars;

class CopyToClipboardSnackBar extends DefaultSnackBar {
  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Die Koordinaten wurden in die Zwischenablage kopiert'),
    );
  }
}
