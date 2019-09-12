import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/pages/json-classes/slide.dart';
import 'package:aceup/util/database.dart';
import 'package:sqflite/sqlite_api.dart';

class Topic {
  int id;
  int courseId;
  int index;
  String title;
  String introduction;
  bool completed;
  Course course;
  List<Slide> slides;
  List<Question> questions;
  Slide lastSlide;

  Topic(
      {this.id,
      this.courseId,
      this.index,
      this.title,
      this.introduction,
      this.completed,
      this.course});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    index = json['index'];
    title = json['title'];
    introduction = json['introduction'].replaceAllMapped(
        RegExp(r'<span class="math-tex"[^>]*>((.|\n)*?)</span>'), (match) {
      return '${match.group(1)}';
    });
    completed =
        json['completed'] == null || json['completed'] == 0 ? false : true;
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    await db.insert(
      'topics',
      this.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['index'] = this.index;
    data['title'] = this.title;
    data['introduction'] = this.introduction;
    data['completed'] = this.completed == null || !this.completed ? 0 : 1;
    return data;
  }

  static Future<Topic> whereId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results =
        await db.query('topics', where: "id = ?", whereArgs: [id], limit: 1);

    Map<String, dynamic> t = results.length > 0 ? results[0] : null;

    Topic topic = Topic.fromJson(t);

    Course course = await Course.whereId(topic.courseId);
    topic.course = course;

    return topic;
  }

  static Future<Topic> firstTopic(int courseId) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query('topics',
        where: "course_id = ?", whereArgs: [courseId], limit: 1);

    Map<String, dynamic> t = results.length > 0 ? results[0] : null;

    Topic topic = Topic.fromJson(t);

    return topic;
  }

  static Future<List<Topic>> whereCourseId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'topics',
      where: "course_id = ?",
      whereArgs: [id],
    );

    List<Topic> profiles = List.generate(results.length, (i) {
      Topic t = Topic.fromJson(results[i]);
      return t;
    });

    return profiles;
  }
}
