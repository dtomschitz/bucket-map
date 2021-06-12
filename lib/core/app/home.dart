import 'package:bucket_map/screens/screens.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static Page page() => MaterialPage<void>(child: HomePage());

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          CountriesScreen(),
          JourneysScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "Karte",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: "Meine Reisen",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "Profil",
          )
        ],
        //showSelectedLabels: false,
        //showUnselectedLabels: false,
      ),
    );
  }
}
