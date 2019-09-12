import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/pages/quiz/sbt.dart';
import 'package:aceup/pages/topic/slides.dart';
import 'package:aceup/util/custom_html.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:aceup/widgets/main-header.dart';
import 'package:aceup/widgets/return-button.dart';
import 'package:flutter/material.dart';

class Introduction extends StatefulWidget {
  final Topic topic;
  Introduction({this.topic});
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 80),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          widget.topic.index.toString().padLeft(2, '0'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(child: MainHeader(widget.topic.title)),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                MainHeader("Introduction."),
                CustomHtml(
                  data: widget.topic.introduction,
                  useRichText: false,
                ),
                SizedBox(
                  height: 30.0,
                ),
                BlockButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return SlideContainer(
                            topic: widget.topic,
                          );
                        },
                      ),
                    );
                  },
                  child: Text("Start Learning"),
                ),
                BlockButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) {
                        return SolveByTopic(
                          topic: widget.topic,
                        );
                      },
                    ));
                  },
                  child: Text("Solve Questions"),
                ),
              ],
            ),
          ),
          // My own custom AppBar
          Positioned(
            top: 0,
            left: 0.0,
            right: 0.0,
            child: Container(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.only(
                  left: 70.0, right: 70.0, top: 60.0, bottom: 10.0),
              child: Text(
                "Introduction",
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
          ReturnButton(onPressed: () {
            Navigator.pop(context);
          }),
          Positioned(
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
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
