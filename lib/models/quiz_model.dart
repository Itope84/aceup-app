import 'dart:convert';

import 'package:aceup/models/learn_model.dart';
import 'package:aceup/models/main_model.dart';
import 'package:aceup/models/top_level_data_model.dart';
import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/pages/json-classes/quiz.dart';
import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/util/random_string.dart';
import 'package:aceup/util/requests.dart';
import 'package:http/http.dart';

class QuizModel extends TopLevelDataModel {
  Quiz _quiz;
  List<Question> _questions;

  Future<Quiz> initQuiz(String type, {Topic topic, Course course}) async {
    print('async stage 1');
    if (_quiz == null || _quiz.questionsMap.length < 1) {
      // generate quiz and add questions
      Quiz quiz = new Quiz(
          id: RandomString.CreateCryptoRandomString(),
          topicId: topic != null ? topic.id : null,
          courseId: course != null ? course.id : null,
          type: type);
      List<Question> questions;
      if (type == Quiz.types['topic']) {
        questions = (await Question.whereTopicId(topic.id));
        questions.shuffle();
        questions = questions.take(10).toList();
      } else if (type == Quiz.types['quiz']) {
        questions = await Question.whereCourseId(course.id);
        print(questions.length);
        questions.shuffle();

        questions = questions.take(20).toList();
      } else {
        // Random question
        questions = await Question.whereCourseId(course.id, limit: 1);
      }

      if (questions.length < 1) {
        // you been offline forever bro
        print('from api');
        questions = await getQuizQuestionsFromApi(
            type, topic != null ? topic.courseId : course.id);
        questions.shuffle();
        questions = questions.take(20).toList();
      }

      quiz.map_questions = questions;

      _questions = questions;

      _quiz = quiz;

      notifyListeners();
    }
    return _quiz;
  }

  List<Question> get questions {
    return _questions;
  }

  Future<int> markQuiz(Quiz quiz) async {
    //submit but don't wait on it
    try {
      quiz.submit();
    } finally {}

    if (quiz.questions == null || quiz.questions.length < 1) {
      await quiz.questionsFromDb;
    }

    int score = 0;

    quiz.getQuestionsAndAttemptsAlreadyLoaded.forEach((question) {
      score = question['selected_option'].isAnswer ? score + 1 : score;
    });

    await quiz.insertToDb();

    return score;
  }

  Quiz get quiz {
    return _quiz;
  }

  /// get quiz with questions from api
  Future<List<Question>> getQuizQuestionsFromApi(
      String type, int courseId) async {
    Map<String, String> headers = await ApiRequest.headers();

    Response response = await get(
        ApiRequest.BASE_URL + '/courses/$courseId/questions/',
        headers: headers);

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
        String res = response.body;
        Map<String, dynamic> data = json.decode(res);
        List<dynamic> jsonqs = data['data'];

        List<Question> questions = List.generate(jsonqs.length, (i) {
          Question t = Question.fromJson(jsonqs[i]);
          t.insertToDb();
          return t;
        }).toList();

        return questions;
      case 401:
        // return to logi
        return null;
      default:
        return null;
    }
  }

  Future<void> submitQuizzes() async {
    List<Quiz> quizzes = await Quiz.whereNotSubmitted();

    Quiz quiz = quizzes.first;

    print("fetching for quiz ${quiz.id}");
    try {
      // try submitting each quiz.
      await quiz.submit();
    } finally {}
  }
}
