import 'package:aceup/pages/challenges/complete-challenge.dart';
import 'package:aceup/pages/json-classes/challenge.dart';
import 'package:aceup/pages/quiz/quiz-question.dart';
import 'package:flutter/material.dart';

class ChallengeWidget extends StatefulWidget {
  final Challenge challenge;
  final Function completeCallback;
  ChallengeWidget({this.challenge, this.completeCallback});
  @override
  _ChallengeWidgetState createState() => _ChallengeWidgetState();
}

class _ChallengeWidgetState extends State<ChallengeWidget> {
  PageController _controller;
  List<ChallengeQuestion> _questions;
  String _type;

  @override
  void initState() {
    super.initState();
    _controller = new PageController();
    _questions = widget.challenge.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          controller: _controller,
          physics: new NeverScrollableScrollPhysics(),
          children: List.generate(_questions.length + 1, (index) {
            return index == _questions.length
                ? CompleteChallenge(
                    challenge: widget.challenge,
                  )
                : QuizQuestion(
                    title: "Challenge",
                    attempt: _questions[index].challengerAttempt != null &&
                            _questions[index].opponentAttempt != null
                        ? _questions[index].question.options.firstWhere(
                            (option) =>
                                option.key ==
                                (widget.challenge.userIsChallenger
                                    ? _questions[index].challengerAttempt
                                    : _questions[index].opponentAttempt))
                        : null,
                    opponentAttempt:
                        _questions[index].challengerAttempt != null &&
                                _questions[index].opponentAttempt != null
                            ? _questions[index].question.options.firstWhere(
                                (option) =>
                                    option.key ==
                                    (!widget.challenge.userIsChallenger
                                        ? _questions[index].challengerAttempt
                                        : _questions[index].opponentAttempt))
                            : null,
                    index: index,
                    total: _questions.length,
                    saveAnswer: (String key) {
                      widget.challenge.userIsChallenger
                          ? _questions[index].challengerAttempt = key
                          : _questions[index].opponentAttempt = key;
                    },
                    question: _questions[index].question,
                    nextSlide: () {
                      widget.challenge.scores.complete && index == _questions.length - 1 ? Navigator.of(context).pop() :
                      _controller.jumpToPage(index + 1);
                    },
                  );
          }),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void submitChallenge() {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.red, statusBarIconBrightness: Brightness.light));
    // model.toggl
  }
}
