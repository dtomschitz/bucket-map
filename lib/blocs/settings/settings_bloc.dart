part of blocs.settings;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(Settings()));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is LoadSettings) {
      yield* _mapLoadSettingsToState();
    } else if (event is SettingsChanged) {
      yield* _mapSettingsChangedToState(event);
    }
  }

  Stream<SettingsState> _mapLoadSettingsToState() async* {
    final sharedPreferencesService = await SharedPreferencesService.instance;
    final settings = sharedPreferencesService.settings;
    yield SettingsState(
      settings != null ? Settings.fromJson(settings) : Settings(),
    );
  }

  Stream<SettingsState> _mapSettingsChangedToState(
      SettingsChanged event) async* {
    final sharedPreferencesService = await SharedPreferencesService.instance;
    final settings = state.settings.merge(event.changes);
    await sharedPreferencesService.setSettings(settings.toJson());

    yield SettingsState(settings);
  }
}
