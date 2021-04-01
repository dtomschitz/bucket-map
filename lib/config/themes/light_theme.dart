import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.green[700],
  appBarTheme: AppBarTheme(
    centerTitle: true,
    titleTextStyle:
        TextStyle(color: Colors.black, backgroundColor: Colors.black),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black, opacity: .87),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: Colors.white
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedIconTheme: IconThemeData(color: Colors.black),
    selectedLabelStyle: TextStyle(color: Colors.black),
    selectedItemColor: Colors.black,
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
  ),
);
