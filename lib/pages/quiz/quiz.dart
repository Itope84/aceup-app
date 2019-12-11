import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/pages/json-classes/quiz.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/pages/quiz/quiz-complete.dart';
import 'package:aceup/pages/quiz/quiz-question.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class QuizWidget extends StatefulWidget {
  final String type;
  QuizWidget({this.type: 'quiz'});
  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  final MainModel _model = new MainModel();
  PageController _controller;
  String _type;
  Future _getQuiz;

  @override
  void initState() {
    super.initState();
    _controller = new PageController();
    _type = widget.type;
    _getQuiz = getQuiz(_model);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: Scaffold(
        body: ScopedModelDescendant<MainModel>(
          builder: (context, widget, model) {
            return FutureBuilder(
              future: _getQuiz,
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
                      title: _type == 'quiz' ? "Quiz" : "Random Question",
                    );
                  case ConnectionState.done:
                    if (snapshot.hasData &&
                        snapshot.data.questionsMap.length > 0) {
                      Course course = model.activeCourseProfile.course;
                      Quiz quiz = snapshot.data;
                      List<Question> questions = model.questions;
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: PageView(
                          controller: _controller,
                          physics: new NeverScrollableScrollPhysics(),
                          children:
                              List.generate(questions.length + 1, (index) {
                            return index == questions.length
                                ? QuizComplete(
                                    quiz: quiz,
                                    showQuizScore: () async {
                                      int score = await model.markQuiz(quiz);
                                      
                                      double percent = score /
                                          (quiz.questions.length > 0
                                              ? quiz.questions.length
                                              : 1) *
                                          100;
                                      
                                      return percent.toInt();
                                    },
                                  )
                                : QuizQuestion(
                                    title: (_type == 'quiz' ? "Quiz - " : "Random Question - ") + course.title,
                                    index: index,
                                    total: questions.length,
                                    saveAnswer: (String key) {
                                      quiz.questionsMap[index]['attempt'] = key;
                                    },
                                    question: questions[index],
                                    nextSlide: () {
                                      _controller.jumpToPage(index + 1);
                                    },
                                  );
                          }),
                          scrollDirection: Axis.horizontal,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      onRefresh: () async {
                        try {
                          await model.getActiveCourseProfileFromDb();
                        } finally {}
                      },
                      child: PageHolder(
                          title: (_type == 'quiz' ? "Quiz" : "Random Question"),
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
                          await model.getActiveCourseProfileFromDb();
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
                        title: "Quiz",
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

  Future<Quiz> getQuiz(MainModel model) async {
    if (model.activeCourseProfile == null) {
      await model.getActiveCourseProfileFromDb();
    }
    if (model.activeCourseProfile != null) {
      return model.initQuiz(_type == 'quiz' ? 'quiz' : 'random', course: model.activeCourseProfile.course);
    }
    return null;
  }

  void setStatusBar() {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.red, statusBarIconBrightness: Brightness.light));
    // model.toggl
  }
}
