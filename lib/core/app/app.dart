library core.app;

import 'dart:async';

import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/core/core.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:bucket_map/shared/shared.dart';
import 'package:bucket_map/widgets/widgets.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

part 'app_base.dart';

class App extends StatelessWidget {
  const App({
    @required this.authenticationRepository,
    @required this.profileRepository,
    @required this.pinsRepository,
    @required this.sharedPreferencesService,
    this.initialSettings,
  });

  final AuthenticationRepository authenticationRepository;
  final ProfileRepository profileRepository;
  final PinsRepository pinsRepository;

  final SharedPreferencesService sharedPreferencesService;
  final Settings initialSettings;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(
              sharedPreferencesService: sharedPreferencesService,
              initialSettings: initialSettings,
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              authenticationRepository: authenticationRepository,
              profileRepository: profileRepository,
            ),
          ),
          BlocProvider<PinsBloc>(
            create: (context) => PinsBloc(
              authRepository: authenticationRepository,
              pinsRepository: pinsRepository,
            ),
          ),
          BlocProvider<CountriesBloc>(
            create: (context) => CountriesBloc(
              profileBloc: BlocProvider.of<ProfileBloc>(context),
            )..add(LoadCountries()),
          ),
          BlocProvider<FilteredCountriesBloc>(
            create: (context) => FilteredCountriesBloc(
              countriesBloc: BlocProvider.of<CountriesBloc>(context),
            ),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Bucket Map',
              themeMode: state.settings.themeMode,
              theme: Themes.buildLightTheme(context),
              darkTheme: Themes.buildDarkTheme(context),
              home: FlowBuilder<AppStatus>(
                state: context.select((AppBloc bloc) => bloc.state.status),
                onGeneratePages: (
                  AppStatus status,
                  List<Page<dynamic>> pages,
                ) {
                  switch (status) {
                    case AppStatus.authenticated:
                      return [AppBase.page()];
                    case AppStatus.unauthenticated:
                    default:
                      return [LoginPage.page()];
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
