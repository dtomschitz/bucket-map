part of blocs.theme;

class ThemeState extends Equatable {
  final ThemeMode mode;
  const ThemeState(this.mode);

  bool get isDarkModeEnabled {
    return mode == ThemeMode.dark;
  }

  @override
  List<Object> get props => [mode];
}
