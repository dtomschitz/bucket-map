part of core.snack_bars;

class CopyToClipboardSnackBar extends SnackBar {
  CopyToClipboardSnackBar()
      : super(
          content: Text('Die Koordinaten wurden in die Zwischenablage kopiert'),
        );
  /*@override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Text('Die Koordinaten wurden in die Zwischenablage kopiert'),
    );
  }*/
}
