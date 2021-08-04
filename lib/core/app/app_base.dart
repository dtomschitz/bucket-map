part of core.app;

class AppBase extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: AppBase());

  @override
  Widget build(BuildContext context) {
    return EventProvider(
      child: CountriesMapScreen(),
    );
  }
}

/*class AppBase extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: AppBase());

  @override
  State createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> {
  final List<Widget> pages = [
    SavedLocationsScreen(key: UniqueKey()),
    CountriesMapScreen(key: UniqueKey()),
    ProfileScreen(key: UniqueKey()),
  ];

  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      body: IndexedStack(
        index: _currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: navigateToPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: "Gespeichert",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: "Karte",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "Profil",
          )
        ],
      ),
    );*/
    return CountriesMapScreen();
  }

  navigateToPage(int page) async {
    if (_currentPage != page) {
      setState(() => _currentPage = page);
    }
  }
}*/
