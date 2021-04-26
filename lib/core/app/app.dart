import 'package:bucket_map/blocs/countries/bloc.dart';
import 'package:bucket_map/core/app/home.dart';
import 'package:bucket_map/core/auth/login.dart';
import 'package:bucket_map/core/app/bloc/bloc.dart';
import 'package:bucket_map/core/auth/repositories/repositories.dart';
import 'package:bucket_map/core/settings/bloc/bloc.dart';
import 'package:bucket_map/core/themes.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    @required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc()..add(LoadSettings()),
          ),
          BlocProvider<CountriesBloc>(
            create: (context) => CountriesBloc()..add(LoadCountriesEvent()),
          )
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  List<Page> _onGenerateAppViewPages(
    AppStatus status,
    List<Page<dynamic>> pages,
  ) {
    switch (status) {
      case AppStatus.authenticated:
        return [HomePage.page()];
      case AppStatus.unauthenticated:
      default:
        return [LoginPage.page()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Bucket Map',
          themeMode: state.settings.themeMode,
          theme: Themes.buildLightTheme(),
          darkTheme: Themes.buildDarkTheme(),
          home: FlowBuilder<AppStatus>(
            state: context.select((AppBloc bloc) => bloc.state.status),
            onGeneratePages: _onGenerateAppViewPages,
          ),
        );
      },
    );
  }
}
