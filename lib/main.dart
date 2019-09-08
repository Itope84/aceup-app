import 'package:aceup/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/entry.dart';
import 'util/const.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
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
  Model _model = new ThemeModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ThemeModel>(
        model: _model,
        child:
            ScopedModelDescendant<ThemeModel>(builder: (context, child, model) {
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor:
                  model.isDark ? Constants.darkBG : Constants.lightPrimary,
              // statusBarColor: Constants.mainWhite,
              // statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
              statusBarIconBrightness:
                  model.isDark ? Brightness.light : Brightness.dark));
          return MaterialApp(
            navigatorObservers: [],
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            // theme: isDark ? Constants.darkTheme : Constants.lightTheme,
            theme: model.isDark ? Constants.darkTheme : Constants.customTheme(primaryColor, secondaryColor),
            home: Entry(),
          );
        }));
  }
}
