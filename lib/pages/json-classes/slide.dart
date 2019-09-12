import 'dart:convert';

import 'package:aceup/pages/json-classes/option.dart';
import 'package:aceup/util/database.dart';
import 'package:sqflite/sqlite_api.dart';

class Slide {
  int id;
  int topicId;
  int index;
  String body;
  bool isQuestion;
  List<Option> options;
  String explanation;

  Slide(
      {this.id,
      this.topicId,
      this.index,
      this.body,
      this.isQuestion,
      this.options,
      this.explanation});

  Slide.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    topicId = json['topic_id'];
    index = json['index'];
    body = json['body'].replaceAllMapped(
        RegExp(r'<span class="math-tex"[^>]*>((.|\n)*?)</span>'), (match) {
      return '${match.group(1)}';
    });

    isQuestion = json['is_question'] == null || json['is_question'] == 0 ? false : true;
    if (json['options'] != null) {
      options = new List<Option>();
      List<dynamic> opts = json['options'] is String ? jsonDecode(json['options']) : json['options'];
      opts.forEach((v) {
        options.add(new Option.fromJson(v));
      });
    }
    explanation = json['explanation'] != null ? json['explanation'].replaceAllMapped(
        RegExp(r'<span class="math-tex"[^>]*>((.|\n)*?)</span>'), (match) {
      return '${match.group(1)}';
    }) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic_id'] = this.topicId;
    data['index'] = this.index;
    data['body'] = this.body;
    data['is_question'] = this.isQuestion == null || !this.isQuestion ? 0 : 1;
    if (this.options != null) {
      data['options'] = json.encode(this.options.map((v) => v.toJson()).toList());
    }
    data['explanation'] = this.explanation;
    return data;
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    await db.insert(
      'slides',
      this.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Slide>> whereTopicId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'slides',
      where: "topic_id = ?",
      whereArgs: [id],
    );

    List<Slide> slides = List.generate(results.length, (i) {
      Slide t = Slide.fromJson(results[i]);
      return t;
    });

    return slides;
  }

  static Future<Slide> whereId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results =
        await db.query('slides', where: "id = ?", whereArgs: [id], limit: 1);

    Map<String, dynamic> t = results.length > 0 ? results[0] : null;

    Slide slide = Slide.fromJson(t);

    return slide;
  }
}
