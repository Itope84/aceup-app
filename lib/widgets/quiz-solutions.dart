import 'package:aceup/pages/json-classes/quiz.dart';
import 'package:aceup/pages/quiz/quiz-question.dart';
import 'package:flutter/material.dart';

class QuizSolution extends StatelessWidget {
  final Quiz quiz;
  QuizSolution({this.quiz});
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: _controller,
          children: List.generate(
              quiz.getQuestionsAndAttemptsAlreadyLoaded.length, (i) {
            return QuizQuestion(
              title: "Quiz Solutions",
              index: i,
              total: quiz.questions.length,
              question: quiz.getQuestionsAndAttemptsAlreadyLoaded[i]
                  ['question'],
              nextSlide: () {
                i == quiz.getQuestionsAndAttemptsAlreadyLoaded.length - 1
                    ? Navigator.of(context).pop()
                    : _controller.jumpToPage(i + 1);
              },
              allowExplanations: true,
              attempt: quiz.getQuestionsAndAttemptsAlreadyLoaded[i]
                  ['selected_option'],
            );
          })),
    );
  }
}
