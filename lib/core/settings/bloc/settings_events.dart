part of blocs.settings;

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class SettingsChanged extends SettingsEvent {
  final Settings changes;
  SettingsChanged({this.changes});

  @override
  List<Object> get props => [changes];
}

