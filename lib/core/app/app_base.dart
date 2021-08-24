part of core.app;

class AppBase extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: AppBase());

  @override
  Widget build(BuildContext context) {
    return CountriesMapScreen();
  }
}
