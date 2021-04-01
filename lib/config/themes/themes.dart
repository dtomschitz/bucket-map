import 'package:bucket_map/config/themes/dark_theme.dart';
import 'package:bucket_map/config/themes/light_theme.dart';

export 'dark_theme.dart';
export 'light_theme.dart';

enum ThemeType {
  Light,
  Dark,
}

final themes = {
  ThemeType.Dark: darkTheme,
  ThemeType.Light: lightTheme,
};
