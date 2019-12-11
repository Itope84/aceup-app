import 'package:flutter/material.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget(
      {Key key,
      @required this.screenWidth,
      @required this.screenheight,
      this.image,
      this.title,
      this.color,
      this.subText})
      : super(key: key);

  final double screenWidth;
  final double screenheight;
  final image;
  final Widget title;
  final Color color;
  final Widget subText;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.only(top: 25),
      decoration: BoxDecoration(color: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.asset(
              image,
              width: screenWidth * 0.9,
              height: screenheight * 0.5,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: Center(
              child: title,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: subText,
          )
        ],
      ),
    );
  }

  TextStyle buildTextStyle(double size) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w900,
      height: 0.5,
    );
  }
}
