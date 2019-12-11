import 'package:aceup/pages/hints.dart';
import 'package:aceup/widgets/hint-button.dart';
import 'package:aceup/widgets/return-button.dart';
import 'package:flutter/material.dart';

class PageHolder extends StatelessWidget {
  final String title;
  final Function onPressReturn;
  final bool disableBack;
  final bool displayHint;
  final Widget child;

  PageHolder(
      {this.title,
      this.onPressReturn,
      this.disableBack: false,
      this.child,
      this.displayHint: true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        // My own custom AppBar
        Positioned(
          top: 0,
          left: 0.0,
          right: 0.0,
          child: Container(
            color: title != null ? Colors.white : Colors.transparent,
            padding: EdgeInsets.only(
                left: 70.0, right: 70.0, top: 60.0, bottom: 10.0),
            child: Text(
              title != null ? title : "",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 20.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        disableBack
            ? Container()
            : ReturnButton(onPressed: () {
                onPressReturn != null
                    ? onPressReturn()
                    : Navigator.pop(context);
              }),
        displayHint
            ? HintButton()
            : Container(),
      ],
    );
  }
}
