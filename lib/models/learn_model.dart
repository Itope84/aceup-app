import 'dart:convert';

import 'package:aceup/models/top_level_data_model.dart';
import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/pages/json-classes/slide.dart';
import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/util/requests.dart';
import 'package:http/http.dart';

abstract class LearnModel extends TopLevelDataModel {
  List<Topic> _topics;
  List<Slide> _slides;

  // Baba use future builder jare
  Future<List<Topic>> topics(int courseId) async {
    if (_topics == null || _topics[0].courseId != courseId) {
      // get topics from db
      await getTopicsFromDb(courseId);
      if (_topics == null || _topics.length < 2) {
        _topics = await getTopicsFromApi(courseId);
        notifyListeners();
      } else {
        // still fetch topics from api, but don't await it.
        getTopicsFromApi(courseId);
      }

      // if after the above, we still get null
    }

    return _topics;
  }

  Future<List<Topic>> getTopicsFromDb(courseId) async {
    List<Topic> topics = await Topic.whereCourseId(courseId);

    _topics = topics;

    notifyListeners();

    return topics;
  }

  Future<List<Topic>> getTopicsFromApi(courseId) async {
    Map<String, String> headers = await ApiRequest.headers();

    Response response = await get(
        ApiRequest.BASE_URL + '/courses/${courseId}/topics',
        headers: headers);

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
        String res = response.body;
        Map<String, dynamic> data = json.decode(res);
        List<dynamic> jsontopics = data['data'];

        List<Topic> topics = List.generate(jsontopics.length, (i) {
          Topic t = Topic.fromJson(jsontopics[i]);
          t.insertToDb();
          return t;
        }).toList();

        _topics = topics;

        // notifyListeners();
        return topics;
        break;
      case 401:
        // return to login
        return null;
        break;
      default:
        return null;
        break;
    }
  }

  Future<List<Slide>> slides(Topic topic) async {
    // get them from db first
    if (_slides == null ||
        _slides.length < 1 ||
        _slides[0].topicId != topic.id) {
      await getSlidesFromDb(topic);
      if (_slides == null || _slides.length < 1) {
        try {
          topic = await getSlidesAndQuestionsFromApi(topic);
          _slides = topic.slides;
          // _questions = topic.questions;
        } finally {}
      } else {
        // get but don't notify
        getSlidesAndQuestionsFromApi(topic);
      }
    }
    return _slides;
  }

  Future<List<Slide>> getSlidesFromDb(Topic topic) async {
    // print(topic.id);
    _slides = await Slide.whereTopicId(topic.id);

    if (_slides != null && _slides.length > 0) {
      notifyListeners();
    }

    return _slides;
  }

  Future<List<Question>> getQuestionsFromDb(Topic topic) async {
    // print(topic.id);
    List<Question> questions = await Question.whereTopicId(topic.id);

    return questions;
  }

  Future<void> fetchContent(CourseProfile profile) async {
    List<Topic> topics = await Topic.whereCourseId(profile.course.id);
    // topics = topics.where(
    // (topic) {

    // topic.slides == null || topic.slides.length < 1) && (topic.questions == null || topic.questions.length < 1)
    // }).toList();
    // only do it for the first top without content
    for (Topic topic in topics) {
      List<Slide> slides = await Slide.whereTopicId(topic.id);
      List<Question> questions = await Question.whereTopicId(topic.id);
      if (slides.length < 1 && questions.length < 1) {
        try {
          await getSlidesAndQuestionsFromApi(topic);
        } finally {}
      }
    }
  }

  // get slides for this course and store them in db
  Future<Topic> getSlidesAndQuestionsFromApi(Topic topic) async {
    // the main point is actually to fetch and store in database

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await get(ApiRequest.BASE_URL + '/topics/${topic.id}',
        headers: headers);

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
        String res = response.body;
        Map<String, dynamic> data = json.decode(res);
        List<dynamic> jsonslides = data['slides'];

        List<Slide> slides = List.generate(jsonslides.length, (i) {
          Slide t = Slide.fromJson(jsonslides[i]);
          t.insertToDb();
          return t;
        }).toList();

        List<dynamic> jsonqs = data['questions'];
        List<Question> questions = List.generate(jsonqs.length, (i) {
          Question q = Question.fromJson(jsonqs[i]);
          q.insertToDb();
          return q;
        }).toList();

        topic.slides = slides;
        topic.questions = questions;
        return topic;
        break;
      case 401:
        // return to login
        break;
      default:
        break;
    }
    return topic;
  }
}
