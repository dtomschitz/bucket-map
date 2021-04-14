import 'package:bucket_map/blocs/theme/bloc.dart';
import 'package:bucket_map/modules/profile/models/user.dart';
import 'package:bucket_map/modules/profile/services/auth.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:bucket_map/config/routes/routes.dart';
import 'package:bucket_map/config/themes/themes.dart';
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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return StreamProvider<CustomUserObject>.value(
          value: AuthService().user,
          initialData: null,
          child: MaterialApp(
            title: 'Bucket Map',
            themeMode: state.mode,
            theme: lightTheme,
            darkTheme: darkTheme,
            
            home: CountriesScreen(),
          ),
        );
      },
    );
  }
}
