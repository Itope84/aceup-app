import 'package:aceup/util/const.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'intro-widget.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();

  final Function onComplete;
  OnBoarding({this.onComplete});
}

class _OnBoardingState extends State<OnBoarding> {
  double screenWidth = 0.0;
  double screenheight = 0.0;

  int currentPageValue = 0;
  int previousPageValue = 0;
  PageController controller;
  double _moveBar = 0.0;

  @override
  void initState() {
    super.initState();

    controller = PageController(initialPage: currentPageValue);

    // set initial page statusbar color
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          // isDark ? Constants.darkBG : Constants.lightPrimary,
          statusBarColor: colors[0],
          // statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
          statusBarIconBrightness: colors[0] == Color(0xFFFEFEFE)
              ? Brightness.dark
              : Brightness.light),
    );
  }

  List<Color> colors = [
    Color(0xFF4996E3),
    Color(0xFFFEFEFE),
    Color(0xFF4996E3)
  ];

  void getChangedPageAndMoveBar(int page) {
    print('page is $page');
    // set statusbar color
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          // isDark ? Constants.darkBG : Constants.lightPrimary,
          statusBarColor: colors[page],
          // statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
          statusBarIconBrightness: colors[page] == Color(0xFFFEFEFE)
              ? Brightness.dark
              : Brightness.light),
    );

    if (previousPageValue == 0) {
      previousPageValue = page;
      _moveBar = _moveBar + 0.14;
    } else {
      if (previousPageValue < page) {
        previousPageValue = page;
        _moveBar = _moveBar + 0.14;
      } else {
        previousPageValue = page;
        _moveBar = _moveBar - 0.14;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;

    final List<Widget> introWidgetsList = <Widget>[
      IntroWidget(
        screenWidth: screenWidth,
        screenheight: screenheight,
        image: 'assets/screen-1.png',
        color: Color(0xFF4996E3),
        title: Text(
          'Learn on the go!',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
        subText: Text(
          "Whether in a bus, waiting for a lecturer or just chilling at a friend's, you can now learn anywhere you are with AceUp.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
      IntroWidget(
        screenWidth: screenWidth,
        screenheight: screenheight,
        color: Color(0xFFFEFEFE),
        image: 'assets/screen-2.png',
        title: Text(
          'Offline Mode!',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xff475472),
            fontSize: 25.0,
          ),
        ),
        subText: Text(
          "Offline? Not to worry. After your first sign in, you do not need internet access to use most features of AceUp.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff475472),
            fontSize: 16.0,
          ),
        ),
      ),
      IntroWidget(
          screenWidth: screenWidth,
          screenheight: screenheight,
          image: 'assets/screen-3.png',
          color: Color(0xFFFEFEFE),
          title: Text(
            'Equations',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xff475472),
              fontSize: 25.0,
            ),
          ),
          subText: Column(
            children: <Widget>[
              Text(
                "Pages with equations may take longer to fully display; Also, note that while selecting options with equations, click outside the white box",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff475472),
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: BlockButton(
                      color: Theme.of(context).primaryColor,
                      child: Text("Let's Go"),
                      onPressed: () {
                        // remove the status bar
                        SystemChrome.setEnabledSystemUIOverlays(
                            SystemUiOverlay.values);
                        SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle(
                              statusBarColor: Constants.lightPrimary,
                              // statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
                              statusBarIconBrightness: Brightness.dark),
                        );
                        widget.onComplete();
                      },
                    ),
                  )
                ],
              )
            ],
          )),
    ];

    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: introWidgetsList.length,
              onPageChanged: (int page) {
                getChangedPageAndMoveBar(page);
              },
              controller: controller,
              itemBuilder: (context, index) {
                return introWidgetsList[index];
              },
            ),
            Stack(
              alignment: AlignmentDirectional.topStart,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          introWidgetsList.map((i) => slidingBar()).toList()),
                ),
                AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.fastOutSlowIn,
                    margin: EdgeInsets.only(
                        bottom: 35, left: screenWidth * _moveBar),
                    //left: screenWidth * _moveBar,
                    child: movingBar()),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Container movingBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 5,
      width: screenWidth * 0.1,
      decoration: BoxDecoration(color: HexColor('d8d8d8')),
    );
  }

  Widget slidingBar() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        height: 5,
        width: screenWidth * 0.1,
        decoration: BoxDecoration(color: HexColor('313543')),
      ),
      onTap: () {
        controller.nextPage(
            curve: Curves.ease, duration: Duration(milliseconds: 500));
      },
    );
  }
}
