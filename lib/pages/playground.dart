import 'package:aceup/util/const.dart';
import 'package:aceup/widgets/screen-title.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Playground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ScreenTitle("Playground"),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Image.asset(
                        'assets/quiz-icon.png',
                        width: 50,
                      ),
                    ),
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40.0)),
                  ),
                  Text(
                    "Quiz",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).accentColor),
                  )
                ],
              )
            ],
          ),

          SizedBox(height: 20.0,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Icon(MdiIcons.medal, color: Constants.mainWhite, size: 40.0,),
                    ),
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40.0)),
                  ),
                  Text(
                    "Challenges",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).accentColor),
                  )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Icon(MdiIcons.formatListBulletedSquare, color: Constants.mainWhite, size: 40.0,),
                    ),
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40.0)),
                  ),
                  Text(
                    "Solve by Topics",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).accentColor),
                  )
                ],
              )
            ],
          ),

          SizedBox(height: 20.0,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Icon(MdiIcons.shuffleVariant, color: Constants.mainWhite, size: 40.0,),
                    ),
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40.0)),
                  ),
                  Text(
                    "Quiz",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).accentColor),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
