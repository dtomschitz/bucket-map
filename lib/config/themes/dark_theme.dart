import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.green[700],
  appBarTheme: AppBarTheme(
    centerTitle: true,
    titleTextStyle:
        TextStyle(color: Colors.black, backgroundColor: Colors.black),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black, opacity: .87),
  ),
);
