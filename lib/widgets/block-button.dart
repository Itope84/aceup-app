import 'package:flutter/material.dart';

class BlockButton extends StatelessWidget {
  @required final Widget child;
  final Function onPressed;
  final Color color;
  BlockButton({this.child, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: RaisedButton(
        child: child,
        onPressed: onPressed,
        color: color != null ? color : Theme.of(context).primaryColor,
        textColor: Colors.white,
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
