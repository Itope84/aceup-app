import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/pages/quiz/sbt.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:flutter/material.dart';

class SlidesComplete extends StatelessWidget {
  final Topic topic;
  SlidesComplete({this.topic});
  @override
  Widget build(BuildContext context) {
    return PageHolder(
      onPressReturn: () {
        Navigator.popUntil(context, (route) {
          return route.settings.name == 'home' || route.isFirst;
        });
      },
      displayHint: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Hurray!!! You made it.",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 40.0),
          Image.asset('assets/hurray.png'),
          SizedBox(height: 40.0),
          Row(
            children: <Widget>[
              Expanded(
                child: BlockButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
                      builder: (context) {
                        return SolveByTopic(
                          topic: topic,
                        );
                      },
                    ), (route) {
                      return route.settings.name == 'introduction' ||
                          route.isFirst;
                    });
                  },
                  child: Text("Solve Questions"),
                ),
              )
            ],
          ),
          // SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              Expanded(
                child: BlockButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.popUntil(context, (route) {
                      return route.settings.name == 'home' || route.isFirst;
                    });
                  },
                  child: Text("Go Back"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
