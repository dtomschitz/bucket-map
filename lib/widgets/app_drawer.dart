import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:bucket_map/config/routes/routes.dart';

class AppDrawer extends StatelessWidget {
  void _navigateTo(BuildContext context, String route, {bool pop}) {
    if (pop) {
      AppRouter.router.pop(context);
    }

    AppRouter.router.navigateTo(context, Routes.search);
  }

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 1,
      indent: 70,
    );

    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(left: 10),
        children: [
          DrawerHeader(
            child: Text('Bucket Map'),
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: Colors.black,
            ),
            title: Text('Suchen'),
            onTap: () => _navigateTo(context, Routes.search, pop: true),
          ),
          ListTile(
            leading: Icon(
              Icons.bookmarks_outlined,
              color: Colors.black,
            ),
            title: Text('Gespeicherte Orte'),
            onTap: () => _navigateTo(context, Routes.countries, pop: true),
          ),
          divider,
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ),
            title: Text('Einstellungen'),
            onTap: () => _navigateTo(context, Routes.countries, pop: true),
          ),
        ],
      ),
    );
  }
}
