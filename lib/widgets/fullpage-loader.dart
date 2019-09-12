import 'package:flutter/material.dart';

class FullPageLoader extends StatelessWidget {
  final Widget child;
  FullPageLoader({this.child});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          // 100 is the height of the navbar, gotta subtract that
          height: MediaQuery.of(context).size.height - 100,
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: 30.0,
              ),
              child != null ? child : Container()
            ],
          ),
        ),
      ],
    );
  }
}
