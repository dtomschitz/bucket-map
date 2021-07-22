import 'package:bucket_map/countries/screens/screens.dart';
import 'package:bucket_map/profile/screens/screens.dart';
import 'package:bucket_map/saved_locations/screens/screens.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: HomePage());

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          CountriesScreenMap(),
          SavedLocationsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: navigateToPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: "Karte",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: "Gespeichert",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "Profil",
          )
        ],
        //showSelectedLabels: false,
        //showUnselectedLabels: false,
      ),
    );
  }

  navigateToPage(int page) async {
    setState(() => _currentPage = page);

    await controller.animateToPage(
      page,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }
}
