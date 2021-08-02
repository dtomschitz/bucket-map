import 'package:flutter/material.dart';

class Themes {
  static final defaultBottomNavigationBarThemeData =
      BottomNavigationBarThemeData(elevation: 16);

  static final defaultBottomSheetThemeData = BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
  );

  static final defaultDialogThemeData = DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
  );

  static final defaultButtonThemeData = ButtonThemeData(
    buttonColor: Colors.deepPurple,
    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
  );

  static final lightIconTheme = IconThemeData(color: Colors.black);

  static final listButtonStyle = TextButton.styleFrom(
    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
    elevation: 0,
    alignment: Alignment.centerLeft,
  );

  static final warningButtonStyle = TextButton.styleFrom(
    primary: Colors.white,
    backgroundColor: Colors.redAccent,
    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
    elevation: 0,
    alignment: Alignment.centerLeft,
  );

  static ThemeData buildDarkTheme() {
    return ThemeData(
      splashFactory: InkRipple.splashFactory,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.grey[850],
      ),
      buttonTheme: defaultButtonThemeData,
      bottomNavigationBarTheme: defaultBottomNavigationBarThemeData,
      dialogTheme: defaultDialogThemeData,
      bottomSheetTheme: defaultBottomSheetThemeData,
    );
  }

  static ThemeData buildLightTheme() {
    return ThemeData(
      splashFactory: InkRipple.splashFactory,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        iconTheme: lightIconTheme,
        backgroundColor: Colors.white,
      ),
      buttonTheme: defaultButtonThemeData,
      bottomNavigationBarTheme: defaultBottomNavigationBarThemeData,
      dialogTheme: defaultDialogThemeData,
      bottomSheetTheme: defaultBottomSheetThemeData,
    );
  }
}
