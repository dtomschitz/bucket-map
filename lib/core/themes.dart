import 'package:bucket_map/core/colors.dart';
import 'package:flutter/material.dart';

class Themes {
  static ThemeData buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.primaryBackground,
      primaryColor: AppColors.primaryBackground,
      focusColor: AppColors.focusColor,
      appBarTheme: const AppBarTheme(brightness: Brightness.dark, elevation: 0),
      accentColor: Colors.red,
      visualDensity: VisualDensity.standard,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        )
      ),
    );
  }

  static ThemeData buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.green[700],
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black, opacity: .87),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(color: Colors.black),
        selectedLabelStyle: TextStyle(color: Colors.black),
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black
          )
        )
      ),
    );
  }
}