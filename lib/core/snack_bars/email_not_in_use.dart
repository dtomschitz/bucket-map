part of core.snack_bars;

class EmailNotInUseSnackBar extends DefaultSnackBar {
  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Die angegebene E-Mail wird für kein Konto verwendet'),
    );
  }
}
