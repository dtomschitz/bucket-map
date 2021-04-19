import 'package:bucket_map/blocs/auth/bloc.dart';
import 'package:bucket_map/blocs/settings/bloc.dart';
import 'package:bucket_map/modules/profile/models/user.dart';
import 'package:bucket_map/modules/profile/services/auth.dart';
import 'package:bucket_map/repositories/user_repository.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:bucket_map/config/routes/routes.dart';
import 'package:bucket_map/config/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/*class App extends StatefulWidget {
  @override
  State createState() => _AppState();
}

class _AppState extends State<App> {
  final UserRepository _userRepository = UserRepository();
  AuthBloc _authBloc;

  _AppState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    AppRouter.router = router;

    @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(userRepository: _userRepository);
    _authBloc.add(AuthVerify());
  }

    @override
  void dispose() {
    _authBloc.
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(value: value)

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
            home: CountriesScreen(),
          ),
        );
      },
    );
  }
}
*/


class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: AppView(),
      ),
    );
  }
}
