import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/pages/json-classes/quiz.dart';
import 'package:aceup/pages/quiz/quiz-complete.dart';
import 'package:aceup/pages/quiz/quiz-question.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizHolder extends StatelessWidget {
  final _controller = new PageController();
  final List<Question> questions;
  final Quiz quiz;
  final String title;
  final Function markQuiz;

  QuizHolder({this.questions, this.quiz, this.title, this.markQuiz});

  /// store last quiz index and id;
  void storeLastQuizIndex(int index, String quizId, {bool unset}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String quizIdName = quiz.type == Quiz.types['topic']
        ? "sbt${quiz.topicId}QuizId"
        : "lastQuizId";
    String indexName = quiz.type == Quiz.types['topic']
        ? "sbt${quiz.topicId}lastQuestionIndex"
        : "quizlastQuestionIndex";
    if (unset != null && unset) {
      // remove it
      prefs.remove(quizIdName);
      prefs.remove(indexName);
    } else {
      print(indexName);
      await prefs.setInt(indexName, index);
      prefs.setString(quizIdName, quizId);
      quiz.insertToDb();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: new NeverScrollableScrollPhysics(),
        // This will handle saving quiz
        // onPageChanged: (int page) {
        //   page < questions.length
        //       ? storeLastQuizIndex(page, quiz.id)
        //       : storeLastQuizIndex(page, quiz.id, unset: true);
        // },
        children: List.generate(questions.length + 1, (index) {
          return index == questions.length
              ? QuizComplete(
                  quiz: quiz,
                  showQuizScore: () async {
                    int score = await markQuiz();
                    return score;
                  },
                )
              : QuizQuestion(
                  allowExplanations: true,
                  title: title,
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
}
