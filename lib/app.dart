import 'package:bucket_map/blocs/settings/bloc.dart';
import 'package:bucket_map/modules/profile/models/user.dart';
import 'package:bucket_map/modules/profile/services/auth.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:bucket_map/config/routes/routes.dart';
import 'package:bucket_map/config/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  State createState() => _AppState();
}

class _AppState extends State<App> {
  _AppState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    AppRouter.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return StreamProvider<CustomUserObject>.value(
          value: AuthService().user,
          initialData: null,
          child: MaterialApp(
            title: 'Bucket Map',
            themeMode: state.settings.themeMode,
            theme: Themes.buildLightTheme(),
            darkTheme: Themes.buildDarkTheme(),
            home: HomeScreen(),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in TabItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          for (final tabItem in TabItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.label,
            )
        ],
        //showSelectedLabels: false,
        //showUnselectedLabels: false,
      ),
    );
  }
}

class TabItem {
  final Widget page;
  final String label;
  final Icon icon;

  TabItem({
    @required this.page,
    @required this.label,
    @required this.icon,
  });

  static List<TabItem> get items => [
        TabItem(
          page: CountriesScreen(),
          icon: Icon(Icons.map_outlined),
          label: "Karte",
        ),
        TabItem(
          page: CountriesScreen(),
          icon: Icon(Icons.explore_outlined),
          label: "Meine Reisen",
        ),
        TabItem(
          page: CountriesScreen(),
          icon: Icon(Icons.account_circle_outlined),
          label: "Profil",
        ),
      ];
}
