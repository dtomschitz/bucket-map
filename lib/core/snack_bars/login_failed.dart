part of core.snack_bars;

class LoginFailed extends DefaultSnackBar {
  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Die Anmeldung wurde aufgrund eines Fehlers abgebrochen'),
    );
  }
}
