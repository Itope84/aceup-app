import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/entry.dart';
import 'util/const.dart';


void main() async{
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;
  String primaryColor = '#04bf68';
  String secondaryColor = '#475472';


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDark ? Constants.mainPrimary : Constants.lightPrimary,
      // statusBarColor: Constants.mainWhite,
      // statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark
    ));
  }

  void changeTheme() {
    setState(() {
      isDark = !isDark;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      // theme: isDark ? Constants.darkTheme : Constants.lightTheme,
      theme: Constants.customTheme(primaryColor, secondaryColor),
      home: Entry(),
    );
  }
}

