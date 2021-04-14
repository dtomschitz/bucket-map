part of blocs.theme;

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.light));

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is LoadTheme) {
      yield* _mapThemeLoadStartedToState();
    } else if (event is ThemeChanged) {
      yield* _mapThemeChangedToState(event.value);
    }
  }

  Stream<ThemeState> _mapThemeLoadStartedToState() async* {
    final sharedPrefService = await SharedPreferencesService.instance;
    final isDarkModeEnabled = sharedPrefService.isDarkModeEnabled;

    if (isDarkModeEnabled == null) {
      sharedPrefService.setDarkModeEnabled(false);
      yield ThemeState(ThemeMode.light);
    } else {
      ThemeMode themeMode =
          isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light;
      yield ThemeState(themeMode);
    }
  }

  Stream<ThemeState> _mapThemeChangedToState(bool value) async* {
    final sharedPrefService = await SharedPreferencesService.instance;
    final isDarkModeEnabled = sharedPrefService.isDarkModeEnabled;

    if (value && !isDarkModeEnabled) {
      await sharedPrefService.setDarkModeEnabled(true);
      yield ThemeState(ThemeMode.dark);
    } else if (!value && isDarkModeEnabled) {
      await sharedPrefService.setDarkModeEnabled(false);
      yield ThemeState(ThemeMode.light);
    }
  }
}
