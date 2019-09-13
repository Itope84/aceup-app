import 'dart:convert';

import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/util/database.dart';
import 'package:aceup/util/requests.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

class Quiz {
  String id;
  int topicId;
  int courseId;
  String type;
  List<Question> questions;
  List<Map<String, dynamic>> questionsMap;
  bool submitted;

  static Map<String, int> scores = {'easy': 2, 'medium': 4, 'difficult': 5};

  // I don't even know why. I guess just for easy readability
  static Map<String, String> types = {
    'topic': 'topic',
    'quiz': 'quiz',
    'random': 'random'
  };

  Quiz(
      {this.id,
      this.topicId,
      this.courseId,
      this.type,
      this.questionsMap,
      this.submitted: false});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicId = json['topic_id'];
    courseId = json['course_id'];
    type = json['type'];

    submitted =
        json['submitted'] == null || json['submitted'] == 0 ? false : true;
    if (json['questions'] != null) {
      questionsMap = json['questions_map'] is String
          ? jsonDecode(json['questions_map'])
          : json['questions_map'];
    }
  }

  Future<List<Map<String, dynamic>>> get questionsFromDb async {
    List<Map<String, dynamic>> qs = new List<Map<String, dynamic>>();
    await this.questionsMap.forEach((q) async {
      Map<String, dynamic> question = new Map<String, dynamic>();
      question['question'] = await Question.whereId(q['question_id']);
      question['attempt'] = q['attempt'];
      qs.add(question);
    });

    return qs;
  }

  /// Warning: This method assumes you already loaded the questions. If not sure, probably call questionsFromDb first
  List<Map<String, dynamic>> get getQuestionsAndAttemptsAlreadyLoaded {
    List<Map<String, dynamic>> qs = new List<Map<String, dynamic>>();
    this.questionsMap.forEach((q) {
      Map<String, dynamic> question = new Map<String, dynamic>();
      question['question'] = this.questions.firstWhere(
          (quest) => quest.id == q['question_id'],
          orElse: () => null);
      question['selected_option'] = question['question']
          .options
          .firstWhere((o) => o.key == q['attempt'], orElse: () => null);
      qs.add(question);
    });

    return qs;
  }

  void set map_questions(List<Question> questions) {
    // this.questions_map
    List<Map<String, dynamic>> map = new List<Map<String, dynamic>>();

    questions.forEach((question) {
      Map<String, dynamic> q = new Map<String, dynamic>();
      q['question_id'] = question.id;
      q['attempt'] = null;
      map.add(q);
    });

    this.questionsMap = map;
    this.questions = questions;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic_id'] = this.topicId;
    data['type'] = this.type;
    data['course_id'] = this.courseId;
    data['submitted'] = this.submitted == null || !this.submitted ? 0 : 1;
    if (this.questionsMap != null) {
      data['questions_map'] = json.encode(this.questionsMap);
    }
    return data;
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    await db.insert(
      'quizzes',
      this.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> submit() async {
    if (this.submitted) {
      return;
    }
    // api  request to submit
    Map<String, dynamic> data = this.toJson();

    if (data['topic_id'] == null) data.remove('topic_id');
    if (data['course_id'] == null) data.remove('course_id');

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await post(ApiRequest.BASE_URL + '/quiz/submit',
        headers: headers, body: json.encode(data));

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        Map<String, dynamic> data = json.decode(response.body);
        // just in case the user closes the app after this page, we still wanna record this so we don't show them this screen anymore.
        this.submitted = true;
        this.insertToDb();
        break;

      case 422:
        Map<String, dynamic> data = json.decode(response.body);
        print(data);
        break;
      default:
        print(statusCode);
        print(response.body);
        break;
    }
  }

  static Future<List<Quiz>> whereTopicId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'quizzes',
      where: "topic_id = ?",
      whereArgs: [id],
    );

    List<Quiz> quizzes = List.generate(results.length, (i) {
      Quiz t = Quiz.fromJson(results[i]);
      return t;
    });

    return quizzes;
  }

  static Future<List<Quiz>> whereCourseId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'quizzes',
      where: "course_id = ?",
      whereArgs: [id],
    );

    List<Quiz> quizzes = List.generate(results.length, (i) {
      Quiz t = Quiz.fromJson(results[i]);
      return t;
    });

    return quizzes;
  }

  static Future<List<Quiz>> whereNotSubmitted() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'quizzes',
      where: "submitted = ?",
      whereArgs: [0],
    );

    List<Quiz> quizzes = List.generate(results.length, (i) {
      Quiz t = Quiz.fromJson(results[i]);
      return t;
    });

    return quizzes;
  }
}
