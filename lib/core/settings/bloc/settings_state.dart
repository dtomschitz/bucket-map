part of blocs.settings;

@immutable
class SettingsState extends Equatable {
  final Settings settings;
  const SettingsState(this.settings);

  @override
  List<Object> get props => [settings];
}
