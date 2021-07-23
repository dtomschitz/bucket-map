library core.app;

import 'package:bucket_map/blocs/blocs.dart';
import 'package:bucket_map/core/core.dart';
import 'package:bucket_map/countries/countries.dart';
import 'package:bucket_map/profile/profile.dart';
import 'package:bucket_map/saved_locations/saved_locations.dart';
import 'package:bucket_map/shared/shared.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home.dart';

class App extends StatelessWidget {
  const App({
    @required this.authenticationRepository,
    @required this.profileRepository,
    @required this.locationsRepository,
    @required this.sharedPreferencesService,
    this.initialSettings,
  });

  final AuthenticationRepository authenticationRepository;
  final ProfileRepository profileRepository;
  final LocationsRepository locationsRepository;

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
          BlocProvider<LocationsBloc>(
            create: (context) => LocationsBloc(
              authRepository: authenticationRepository,
              locationsRepository: locationsRepository,
            ),
          ),
          BlocProvider<FilteredCountriesBloc>(
            create: (context) => FilteredCountriesBloc(
              profileBloc: BlocProvider.of<ProfileBloc>(context),
            ),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
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
            onGeneratePages: (
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
            },
          ),
        );
      },
    );
  }
}
