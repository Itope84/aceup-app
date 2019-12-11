import 'package:aceup/pages/hints.dart';
import 'package:flutter/material.dart';

class HintButton extends StatelessWidget {
  @required
  final Function onPressed;

  HintButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Always has to be used in a stack
    return Positioned(
      top: 50,
      width: 60.0,
      right: 0.0,
      child: RaisedButton(
        elevation: 0.0,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.lightbulb_outline,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0))),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Hint(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }
}
