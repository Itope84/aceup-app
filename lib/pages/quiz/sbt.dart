import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/pages/json-classes/quiz.dart';
import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/pages/quiz/quiz-holder.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolveByTopic extends StatefulWidget {
  final Topic topic;
  SolveByTopic({this.topic});
  @override
  _SolveByTopicState createState() => _SolveByTopicState();
}

class _SolveByTopicState extends State<SolveByTopic> {
  final MainModel _model = new MainModel();
  PageController _controller;
  Topic topic;
  Future<Quiz> _initQuiz;

  @override
  void initState() {
    super.initState();
    topic = widget.topic;
    _controller = new PageController();
    _initQuiz = _model.initQuiz('topic', topic: topic);
    // initQuiz();
  }

  /// Handles checking if quiz is in progress
  Future<Quiz> initQuiz() async {
    Future<Quiz> _quiz;
    // check if quiz is saved.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String quizIdName = "sbt${topic.id}QuizId";
    String oldQuizId = await prefs.getString(quizIdName);

    Quiz quiz = oldQuizId != null ? await Quiz.whereId(oldQuizId) : null;

    if (quiz != null && quiz.questionsMap != null) {
      // get last quiz question
      String indexName = "sbt${topic.id}lastQuestionIndex";

      int lastIndex = await prefs.getInt(indexName);
      // show modal
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Continue from saved quiz?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('There is a previously saved quiz on this topic'),
                  Text('Do you want to continue?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('New Quiz'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Continue'),
                onPressed: () {
                  _quiz = _model.initQuiz('topic', topic: topic, oldQuiz: quiz);
                  setState(() {
                    _controller = new PageController(
                        initialPage: lastIndex != null ? lastIndex : 0);
                    _initQuiz = _quiz;
                  });
                  print(_initQuiz);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      _quiz = _model.initQuiz('topic', topic: topic);
      setState(() {
        _initQuiz = _quiz;
      });
    }

    return _quiz;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: Scaffold(
        body: ScopedModelDescendant<MainModel>(
          builder: (context, widget, model) {
            return FutureBuilder(
              future: _initQuiz,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return PageHolder(
                      disableBack: true,
                      child: Center(
                          child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(),
                      )),
                      title: topic.title,
                    );
                  case ConnectionState.done:
                    if (snapshot.hasData &&
                        snapshot.data.questionsMap.length > 0) {
                      List<Question> questions = model.questions;
                      return QuizHolder(
                        questions: questions,
                        quiz: snapshot.data,
                        title: topic.title,
                        markQuiz: () async {
                          int score = await model.markQuiz(snapshot.data);
                          double percent = score /
                              (snapshot.data.questions.length > 0
                                  ? snapshot.data.questions.length
                                  : 1) *
                              100;
                          return percent.toInt();
                        },
                      );
                    }

                    return RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      onRefresh: () async {
                        try {
                          await model.initQuiz('topic', topic: topic);
                        } finally {}
                      },
                      child: PageHolder(
                          title: topic.title,
                          child: ListView(
                            children: <Widget>[
                              Container(
                                // 100 is the height of the navbar, gotta subtract that
                                height:
                                    MediaQuery.of(context).size.height - 100,
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
                                    Text(
                                      "Fetching questions. \n Don't worry, this only happens the first time. \n If it takes too long, swipe down to refresh",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.blueGrey),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                    );
                  default:
                    return RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      onRefresh: () async {
                        try {
                          await model.initQuiz('topic', topic: topic);
                        } finally {}
                      },
                      child: PageHolder(
                        child: ListView(
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
                                    "Something went wrong. \n Please check your internet and pull down to refresh",
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
                        ),
                        title: topic.title,
                      ),
                    );
                }
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void setStatusBar() {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.red, statusBarIconBrightness: Brightness.light));
    // model.toggl
  }
}
