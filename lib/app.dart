import 'package:bucket_map/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:bucket_map/config/routes/routes.dart';
import 'package:bucket_map/config/themes/themes.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

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
    return MaterialApp(
      title: 'Bucket Map',
      theme: themes[ThemeType.Light],
      home: CountriesScreen(),
      //initialRoute: Routes,
      //onGenerateRoute: AppRouter.router.generator,
    );
  }
}
