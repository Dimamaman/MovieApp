import 'package:flutter/material.dart';
import 'package:common/common.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'IBMPlexSans',
    primaryColor: ColorPalettes.lightPrimary,
    dividerColor: ColorPalettes.darkBG,
    scaffoldBackgroundColor: ColorPalettes.lightBG,
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        color: ColorPalettes.darkBG,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'IBMPlexSans',
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorPalettes.lightAccent,
    ),
    colorScheme: ColorScheme.light(
      primary: ColorPalettes.lightPrimary,
      secondary: ColorPalettes.lightAccent,
      surface: ColorPalettes.lightBG,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'IBMPlexSans',
    brightness: Brightness.dark,
    primaryColor: ColorPalettes.darkPrimary,
    dividerColor: ColorPalettes.lightPrimary,
    scaffoldBackgroundColor: ColorPalettes.darkBG,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorPalettes.darkPrimary,
      titleTextStyle: TextStyle(
        color: ColorPalettes.lightBG,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        fontFamily: 'IBMPlexSans',
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorPalettes.darkAccent,
    ),
    colorScheme: ColorScheme.dark(
      primary: ColorPalettes.darkPrimary,
      secondary: ColorPalettes.darkAccent,
      surface: ColorPalettes.darkBG,
    ),
  );
}
