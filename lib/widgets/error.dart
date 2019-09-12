import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ErrorOccured extends StatelessWidget {
  final String customText;
  ErrorOccured({this.customText});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: Icon(
                  MdiIcons.alertCircle,
                  size: 100.0,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                customText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "If this continues, please contact us",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey),
              )
            ],
          ),
        ),
      ],
    );
  }
}
