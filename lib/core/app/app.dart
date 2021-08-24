library core.app;

import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/core/core.dart';
import 'package:bucket_map/screens/screens.dart';
import 'package:bucket_map/shared/shared.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final AuthRepository authenticationRepository;
  final ProfileRepository profileRepository;
  final PinsRepository pinsRepository;

  final SharedPreferencesService sharedPreferencesService;
  final Settings initialSettings;

  @override
  Widget build(BuildContext context) {
    final _settingsBloc = SettingsBloc(
      sharedPreferencesService: sharedPreferencesService,
      initialSettings: initialSettings,
    );

    final _profileBloc = ProfileBloc(
      authenticationRepository: authenticationRepository,
      profileRepository: profileRepository,
    );

    final _pinsBloc = PinsBloc(
      authRepository: authenticationRepository,
      pinsRepository: pinsRepository,
    );

    final _countriesBloc = CountriesBloc(profileBloc: _profileBloc);

    final _filteredCountriesBloc = FilteredCountriesBloc(
      countriesBloc: _countriesBloc,
    );

    final _appBloc = AppBloc(
      authenticationRepository: authenticationRepository,
      countriesBloc: _countriesBloc,
      pinsBloc: _pinsBloc,
      profileBloc: _profileBloc,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: profileRepository),
        RepositoryProvider.value(value: pinsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>.value(value: _appBloc),
          BlocProvider<SettingsBloc>.value(value: _settingsBloc),
          BlocProvider<ProfileBloc>.value(value: _profileBloc),
          BlocProvider<PinsBloc>.value(value: _pinsBloc),
          BlocProvider<CountriesBloc>.value(value: _countriesBloc),
          BlocProvider<FilteredCountriesBloc>.value(
            value: _filteredCountriesBloc,
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
