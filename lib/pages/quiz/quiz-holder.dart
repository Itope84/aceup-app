import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/pages/json-classes/quiz.dart';
import 'package:aceup/pages/quiz/quiz-complete.dart';
import 'package:aceup/pages/quiz/quiz-question.dart';
import 'package:flutter/material.dart';

class QuizHolder extends StatelessWidget {
  final _controller = new PageController();
  final List<Question> questions;
  final Quiz quiz;
  final String title;
  final Function markQuiz;

  QuizHolder({this.questions, this.quiz, this.title, this.markQuiz});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: new NeverScrollableScrollPhysics(),
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
