import 'dart:convert';

import 'package:aceup/pages/json-classes/option.dart';
import 'package:aceup/util/database.dart';
import 'package:sqflite/sqlite_api.dart';

class Question {
  int id;
  int topicId;
  String body;
  List<Option> options;
  String difficulty;
  String explanation;

  Question({
    this.id,
    this.topicId,
    this.body,
    this.options,
    this.difficulty,
    this.explanation,
  });

  int get points {
    Map<String, int> pointSys = {'easy': 2, 'medium': 3, 'difficult': 5};
    return pointSys[this.difficulty != null ? this.difficulty : 'medium'];
  }

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicId = json['topic_id'];
    body = json['body'].replaceAllMapped(
        RegExp(r'<span class="math-tex"[^>]*>((.|\n)*?)</span>'), (match) {
      return '${match.group(1)}';
    });
    if (json['options'] != null) {
      options = new List<Option>();
      List<dynamic> opts = json['options'] is String
          ? jsonDecode(json['options'])
          : json['options'];
      opts.forEach((v) {
        v['body'].replaceAllMapped(
            RegExp(r'<span class="math-tex"[^>]*>((.|\n)*?)</span>'), (match) {
          return '${match.group(1)}';
        });

        options.add(new Option.fromJson(v));
      });
    }
    difficulty = json['difficulty'];
    explanation = json['explanation'] != null
        ? json['explanation'].replaceAllMapped(
            RegExp(r'<span class="math-tex"[^>]*>((.|\n)*?)</span>'), (match) {
            return '${match.group(1)}';
          })
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic_id'] = this.topicId;
    data['body'] = this.body;
    if (this.options != null) {
      data['options'] =
          json.encode(this.options.map((v) => v.toJson()).toList());
    }
    data['difficulty'] = this.difficulty;
    data['explanation'] = this.explanation;
    return data;
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    await db.insert(
      'questions',
      this.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Question>> whereTopicId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'questions',
      where: "topic_id = ?",
      whereArgs: [id],
    );

    List<Question> questions = List.generate(results.length, (i) {
      Question t = Question.fromJson(results[i]);
      return t;
    });

    return questions;
  }

  /// Get Questions in random order
  static Future<List<Question>> whereCourseId(int id, {int limit}) async {
    Future database = DB.initialize();
    final Database db = await database;

    String query =
        'SELECT * FROM questions WHERE topic_id IN (SELECT id FROM topics WHERE course_id = $id) ORDER BY RANDOM()' +
            (limit == null ? '' : ' LIMIT $limit');

    List<Map<String, dynamic>> results = await db.rawQuery(query);

    List<Question> questions = List.generate(results.length, (i) {
      Question t = Question.fromJson(results[i]);
      return t;
    });

    return questions;
  }

  static Future<Question> whereId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'questions',
      where: "id = ?",
      whereArgs: [id],
    );

    List<Question> questions = List.generate(results.length, (i) {
      Question t = Question.fromJson(results[i]);
      return t;
    });

    return questions.length != 0 ? questions.first : null;
  }
}
