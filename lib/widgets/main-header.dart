import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final String text;
  final Color color;
  final int fontSize;
  MainHeader(this.text, {this.color, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color != null ? color : Theme.of(context).accentColor,
          fontSize: fontSize != null ? fontSize : 25.0,
          fontWeight: FontWeight.w600),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
