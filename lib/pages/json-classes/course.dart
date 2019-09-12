import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/util/database.dart';
import 'package:sqflite/sqlite_api.dart';

class Course {
  int id;
  String title;
  String description;
  String featuredImage;
  String colorScheme;
  String createdAt;
  String updatedAt;
  Topic activeTopic;
  List<Topic> topics;

  Course(
      {this.id,
      this.title,
      this.description,
      this.featuredImage,
      this.colorScheme,
      this.createdAt,
      this.updatedAt,
      this.activeTopic});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    featuredImage = json['featured_image'];
    colorScheme = json['color_scheme'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    activeTopic = json['first_topic'] != null
        ? new Topic.fromJson(json['first_topic'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['featured_image'] = this.featuredImage;
    data['color_scheme'] = this.colorScheme;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    await db.insert(
      'courses',
      this.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Course> whereId(int id) async {
    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> result =
        await db.query('courses', where: "id = ?", whereArgs: [id], limit: 1);
    Map<String, dynamic> course = result.length == 0 ? null : result[0];
    return course != null ? Course.fromJson(course) : course;
  }
}
