import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:fancy_on_boarding/page_model.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        pageList: pageList,
        mainPageRoute: '/',
      ),
    );
  }

  final pageList = [
    PageModel(
        color: const Color(0xFF4996E3),
        heroAssetPath: 'assets/screen-1.png',
        title: Text('Learn on the go!',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Whether in a bus, waiting for a lecturer or just chilling at a friend's, you can now learn anywhere you are with AceUp.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
        iconAssetPath: 'assets/avatars/003.png'),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroAssetPath: 'assets/screen-2.png',
      title: Text('Offline Mode',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xff475472),
            fontSize: 34.0,
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Text(
            'Offline? Not to worry. After your first sign in, you do not need internet access to use most features of AceUp.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff475472),
              fontSize: 18.0,
            )),
      ),
      iconAssetPath: 'assets/avatars/002.png',
    ),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroAssetPath: 'assets/mth-105.png',
      title: Text('Beautiful Equations',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
            'Pages with equations may take longer to fully display; Also, note that while selecting options with equations, click outside the white box',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
      ),
      iconAssetPath: 'assets/avatars/001.png',
    ),
  ];
}
