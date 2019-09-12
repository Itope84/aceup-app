import 'package:aceup/pages/json-classes/quiz.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/pages/quiz/quiz.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:aceup/widgets/error.dart';
import 'package:aceup/widgets/fullpage-loader.dart';
import 'package:aceup/widgets/quiz-solutions.dart';
import 'package:flutter/material.dart';

class QuizComplete extends StatelessWidget {
  final Quiz quiz;
  final Function showQuizScore;
  QuizComplete({this.quiz, this.showQuizScore});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: showQuizScore(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return PageHolder(
              title: "Quiz",
              child: FullPageLoader(
                child: Text(
                  "Computing Score, please wait...",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              return Scaffold(
                backgroundColor: snapshot.data > 60
                    ? Theme.of(context).primaryColor
                    : Colors.red,
                body: SingleChildScrollView(
                  child: PageHolder(
                      onPressReturn: () {
                        Navigator.popUntil(context, (route) {
                          return route.settings.name == 'home' || route.isFirst;
                        });
                      },
                      displayHint: false,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 80.0),
                            Text(
                              snapshot.data > 60
                                  ? "Congratulations"
                                  : "Almost There",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 40.0),
                            Image.asset(
                              snapshot.data > 60
                                  ? 'assets/gt60.png'
                                  : 'assets/lt60.png',
                              height: 250,
                            ),
                            SizedBox(height: 40.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Score:",
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      color: Theme.of(context).accentColor),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data.toString() + "%",
                                  style: TextStyle(
                                      fontSize: 60.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: BlockButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  QuizSolution(
                                                    quiz: quiz,
                                                  )));
                                    },
                                    child: Text(
                                      "View Solutions",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: BlockButton(
                                    color: Theme.of(context).accentColor,
                                    onPressed: () {
                                      quiz.type == 'random'
                                          ? Navigator.pushAndRemoveUntil(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizWidget(
                                                        type: 'random',
                                                      )), (route) {
                                              return route.settings.name ==
                                                      'home' ||
                                                  route.isFirst;
                                            })
                                          : Navigator.popUntil(context,
                                              (route) {
                                              return route.settings.name ==
                                                      'home' ||
                                                  route.isFirst;
                                            });
                                    },
                                    child: Text( quiz.type == 'random' ? "Try Again" : "Done"),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              );
            }

            return PageHolder(
              child: ErrorOccured(
                customText: "Sorry, Something went wrong.",
              ),
              title: "Quiz Results",
            );
          default:
            return PageHolder(
              child: ErrorOccured(
                customText: "Sorry, Something went wrong.",
              ),
              title: "Quiz Results",
            );
        }
      },
    );
  }
}
