import 'package:flutter/material.dart';

class Themes {
  static ThemeData buildDarkTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(centerTitle: false),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(elevation: 16),
      brightness: Brightness.dark,
    );
  }

  static ThemeData buildLightTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(centerTitle: false),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(elevation: 16),
      brightness: Brightness.light,
    );
  }
}
