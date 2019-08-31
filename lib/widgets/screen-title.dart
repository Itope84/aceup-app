import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String text;
  ScreenTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 30),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).accentColor),
      ),
    );
  }
}
