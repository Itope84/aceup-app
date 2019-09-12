import 'package:aceup/pages/json-classes/slide.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:aceup/widgets/question.dart';
import 'package:flutter/material.dart';

class QuestionSlide extends StatefulWidget {
  final Slide slide;
  final String title;
  final Function nextSlide;
  QuestionSlide({this.slide, this.title, this.nextSlide});

  @override
  QuestionSlide_State createState() => QuestionSlide_State();
}

class QuestionSlide_State extends State<QuestionSlide> {
  bool _ready;

  @override
  void initState() {
    super.initState();

    _ready = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 100),

                  Text(
                    "Question",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),

                  // body
                  QuestionWidget(
                      question: widget.slide,
                      onAnswer: () {
                        setState(() {
                          _ready = true;
                        });
                      }),

                  SizedBox(
                    height: 20.0,
                  ),

                  _ready
                      ? BlockButton(
                          onPressed: () {
                            widget.nextSlide();
                          },
                          child: Text("Continue"),
                        )
                      : Container(),
                  Text(
                    "Explanations are in the next slide",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  )
                ],
              ),
            ),

            // My own custom AppBar
            Positioned(
              top: 0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.only(
                    left: 70.0, right: 70.0, top: 60.0, bottom: 10.0),
                child: Text(
                  widget.title,
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
      ),
    );
  }
}
