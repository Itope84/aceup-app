import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/util/database.dart';
import 'package:sqflite/sqflite.dart';

class CourseProfile {
  int id;
  int userId;
  int points;
  int courseId;
  Course course;

  CourseProfile(
      {this.id, this.userId, this.points, this.courseId, this.course});

  CourseProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    points = json['points'];
    courseId = json['course_id'];
    course =
        json['course'] != null ? new Course.fromJson(json['course']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['points'] = this.points;
    data['course_id'] = this.courseId;
    return data;
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    await db.insert(
      'course_profiles',
      this.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<CourseProfile>> whereUserId(int userId) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'course_profiles',
      where: "user_id = ?",
      whereArgs: [userId]
    );

    List<CourseProfile> profiles = List.generate(results.length, (i) {
      CourseProfile cp = CourseProfile.fromJson(results[i]);
      return cp;
    });
    
    Future<List<CourseProfile>> attachCourses () async {
      List<CourseProfile> profs = [];
      for (var i = 0; i < profiles.length; i++) {
        profs.add(profiles[i]);
        Course course = await Course.whereId(profiles[i].courseId);
        profs[i].course = course;
      }
      return profs;
    };

    profiles = await attachCourses();

    return profiles;
  }

  static Future<CourseProfile> whereCourseId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'course_profiles',
      where: "course_id = ?",
      whereArgs: [id],
      limit: 1
    );

    Map<String, dynamic> prof = results.length > 0 ? results[0] : null;

    
    CourseProfile cp = CourseProfile.fromJson(prof);

    Course course = await Course.whereId(cp.courseId);
      cp.course = course;

    return cp;
  }

  static Future<CourseProfile> whereId(int id) async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      'course_profiles',
      where: "id = ?",
      whereArgs: [id],
      limit: 1
    );

    Map<String, dynamic> prof = results.length > 0 ? results[0] : null;

    
    CourseProfile cp = CourseProfile.fromJson(prof);

    Course course = await Course.whereId(cp.courseId);
      cp.course = course;

    return cp;
  }
}