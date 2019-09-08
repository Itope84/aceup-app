import 'package:flutter/material.dart';

class ReturnButton extends StatelessWidget {
  @required final Function onPressed;

  ReturnButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Always has to be used in a stack
    return Positioned(
      top: 50,
      left: 0.0,
      width: 60.0,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        elevation: 0.0,
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))),
        onPressed: onPressed,
      ),
    );
  }
}
