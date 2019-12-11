import 'package:aceup/pages/json-classes/challenge.dart' as prefix0;
import 'package:aceup/pages/json-classes/option.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/pages/quiz/explanation.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:aceup/widgets/hint-button.dart';
import 'package:aceup/widgets/question.dart';
import 'package:aceup/widgets/return-button.dart';
import 'package:flutter/material.dart';

class ChallengeQuestion extends StatefulWidget {
  final prefix0.ChallengeQuestion question;
  final int index;
  final int total;
  final String title;
  /// If attempt is not null, then that means we've come around to show the solutions and their explanations
  final Option attempt;
  /// If allowExplanations is set, such as in random question and sbt, then once user selects ansers, we show the explanation button
  final bool allowExplanations;
  final Function nextSlide;
  final Function saveAnswer;
  ChallengeQuestion(
      {this.question,
      this.title,
      this.nextSlide,
      this.index,
      this.total,
      this.attempt,
      this.allowExplanations: false,
      this.saveAnswer});

  @override
  ChallengeQuestion_State createState() => ChallengeQuestion_State();
}

class ChallengeQuestion_State extends State<ChallengeQuestion> {
  bool _ready;
  String _optionSelected;
  Question question;

  @override
  void initState() {
    super.initState();
    question = widget.question.question;
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

                  SizedBox(height: 100),

                  Text(
                    (widget.index + 1).toString() +
                        '/' +
                        widget.total.toString(),
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),

                  // body
                  QuestionWidget(
                    question: widget.question,
                    attempt: widget.attempt,
                    disableOptions: _ready || (widget.attempt != null),
                    onAnswer: (String key) {
                      setState(() {
                        _optionSelected = key;
                        widget.saveAnswer(key);
                      });
                      // make model update the quiz
                    },
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  _optionSelected != null && !_ready
                      ? BlockButton(
                          color: Colors.orange[300],
                          onPressed: () {
                            setState(() {
                              _ready = true;
                            });
                          },
                          child: Text("Confirm"),
                        )
                      : Container(),

                  _ready || widget.attempt != null
                      ? BlockButton(
                          onPressed: () {
                            widget.nextSlide();
                          },
                          child: Text(widget.attempt != null ? "Next" : "Continue"),
                        )
                      : Container(),

                  (_ready && widget.allowExplanations) || widget.attempt != null
                      ? BlockButton(
                        color: Theme.of(context).accentColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Explanation(
                                    question: widget.question.question,
                                  ),
                                  fullscreenDialog: true,
                                ));
                          },
                          child: Text("View Explanation"),
                        )
                      : Container()
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
            widget.attempt != null ? ReturnButton(onPressed: () {
              Navigator.pop(context);
            }) : Container(),
            HintButton(),
          ],
        ),
      ),
    );
  }
}
