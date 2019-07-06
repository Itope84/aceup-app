import 'package:flutter/material.dart';
class Constants{

  static String appName = "Foody Bite";

  //Colors for theme
  static Color mainWhite = Color(0xfffefefe);
  static Color mainPrimary = Color(0xff04bf68);
  static Color mathPrimary = Color(0xff475472);
  static Color mainPrimaryDark = Color(0xff00600f);
  static Color mainPrimaryLight = Color(0xff6abf69);
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blueGrey[900];
  static Color darkAccent = Colors.white;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;

  static ThemeData mainLightTheme = ThemeData(
    primaryTextTheme: TextTheme(
      title: TextStyle(color: mainPrimary, fontFamily: "karla"),
      body1: TextStyle(fontFamily: "karla"),
      body2: TextStyle(fontFamily: "karla")
    ),
    textTheme: TextTheme(
      title: TextStyle(color: mainPrimary, fontFamily: "karla"),
      body1: TextStyle(fontFamily: "karla"),
      body2: TextStyle(fontFamily: "karla")
    ),
    backgroundColor: mainWhite,
    primaryColor: mainWhite,
    accentColor:  mainPrimary,
    cursorColor: mainPrimary,
    scaffoldBackgroundColor: mainWhite,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: mainPrimary,
          fontSize: 18.0,
          fontFamily: "karla",
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor:  lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    ),
  );
}