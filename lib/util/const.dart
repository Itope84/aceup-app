import 'package:flutter/material.dart';

class Constants {
  static String appName = "AceUp";

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

  static ThemeData customTheme(String mainHexCode, String secondaryHexCode) {
    return ThemeData(
        primaryTextTheme: TextTheme(
            title: TextStyle(color: HexColor(mainHexCode), fontFamily: "karla"),
            body1: TextStyle(fontFamily: "karla"),
            body2: TextStyle(fontFamily: "karla")),
        textTheme: TextTheme(
            title: TextStyle(color: HexColor(mainHexCode), fontFamily: "karla"),
            body1: TextStyle(fontFamily: "karla"),
            body2: TextStyle(fontFamily: "karla")),
        backgroundColor: mainWhite,
        primaryColor: HexColor(mainHexCode),
        accentColor: HexColor(secondaryHexCode),
        cursorColor: HexColor(secondaryHexCode),
        scaffoldBackgroundColor: mainWhite,
        appBarTheme: AppBarTheme(
            elevation: 0,
            textTheme: TextTheme(
              title: TextStyle(
                color: HexColor(secondaryHexCode),
                fontSize: 18.0,
                fontFamily: "karla",
                fontWeight: FontWeight.w800,
              ),
            ),
            iconTheme: IconThemeData(color: HexColor(secondaryHexCode)),
            color: mainWhite),
        bottomAppBarTheme: BottomAppBarTheme(
          color: HexColor(mainHexCode),
        ));
  }

  static ThemeData mainLightTheme = ThemeData(
    primaryTextTheme: TextTheme(
        title: TextStyle(color: mainPrimary, fontFamily: "karla"),
        body1: TextStyle(fontFamily: "karla"),
        body2: TextStyle(fontFamily: "karla")),
    textTheme: TextTheme(
        title: TextStyle(color: mainPrimary, fontFamily: "karla"),
        body1: TextStyle(fontFamily: "karla"),
        body2: TextStyle(fontFamily: "karla")),
    backgroundColor: mainWhite,
    primaryColor: mainWhite,
    accentColor: mainPrimary,
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
    accentColor: lightAccent,
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

  static Widget defaultInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: new Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Constants.mainPrimary,
          fontSize: 15.0,
        ),
      ),
    );
  }

  static Widget defaultInputWidget(
      {String label,
      TextInputType type: TextInputType.text,
      bool disabled: false,
      String placeholder,
      bool obscureText: false,
      TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        defaultInputLabel(label),
        Container(
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Constants.mainPrimary,
                  width: 0.5,
                  style: BorderStyle.solid),
            ),
          ),
          padding: const EdgeInsets.only(left: 0.0, right: 10.0),
          child: TextField(
            obscureText: obscureText,
            keyboardType: type,
            controller: controller,
            enabled: !disabled,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  static Widget inputStyle2(TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextField(
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.blueGrey[300],
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "E.g: New York, United States",
            prefixIcon: Icon(
              Icons.location_on,
              color: Colors.blueGrey[300],
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey[300],
            ),
          ),
          maxLines: 1,
          controller: controller,
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
