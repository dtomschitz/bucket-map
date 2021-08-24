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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100.0),
      side: BorderSide(color: Colors.red),
    ),
  );

  static final textButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    ),
  );

  static final outlinedButtonThemeData = OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    ),
  );

  static final lightIconTheme = IconThemeData(color: Colors.black);

  static ThemeData buildDarkTheme(BuildContext context) {
    return ThemeData(
      splashFactory: InkRipple.splashFactory,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.grey[850],
      ),
      scaffoldBackgroundColor: Colors.grey[850],
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      buttonTheme: defaultButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonThemeData,
      bottomNavigationBarTheme: defaultBottomNavigationBarThemeData,
      dialogTheme: defaultDialogThemeData,
      bottomSheetTheme: defaultBottomSheetThemeData,
    );
  }

  static ThemeData buildLightTheme(BuildContext context) {
    return ThemeData(
      splashFactory: InkRipple.splashFactory,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        iconTheme: lightIconTheme,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      buttonTheme: defaultButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonThemeData,
      bottomNavigationBarTheme: defaultBottomNavigationBarThemeData,
      dialogTheme: defaultDialogThemeData,
      bottomSheetTheme: defaultBottomSheetThemeData,
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: Colors.black),
      ),
    );
  }
}
