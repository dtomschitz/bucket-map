part of blocs.settings;

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    @required SharedPreferencesService sharedPreferencesService,
    Settings initialSettings,
  })  : _sharedPreferencesService = sharedPreferencesService,
        super(SettingsState(initialSettings ?? Settings()));

  final SharedPreferencesService _sharedPreferencesService;

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsChanged) {
      yield* _mapSettingsChangedToState(event);
    }
  }

  Stream<SettingsState> _mapSettingsChangedToState(
    SettingsChanged event,
  ) async* {
    final settings = state.settings.merge(event.changes);
    await _sharedPreferencesService.setSettings(settings.toJson());

    yield SettingsState(settings);
  }
}
