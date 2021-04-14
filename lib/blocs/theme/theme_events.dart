part of blocs.theme;

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final bool value;

  ThemeChanged(this.value) : assert(value != null);

  @override
  List<Object> get props => [value];
}
