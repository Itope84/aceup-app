import 'package:aceup/util/database.dart';
import 'package:sqflite/sqlite_api.dart';

import 'user.dart';
import 'course.dart';

class SubscriptionItem {
  int pinId;
  int courseId;
  int userId;
  String updatedAt;
  String createdAt;
  int id;
  Course course;
  User user;

  SubscriptionItem(
      {this.pinId,
      this.courseId,
      this.userId,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.course,
      this.user});

  SubscriptionItem.fromJson(Map<String, dynamic> json) {
    pinId = json['pin_id'];
    courseId = json['course_id'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    course =
        json['course'] != null ? new Course.fromJson(json['course']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pin_id'] = this.pinId;
    data['course_id'] = this.courseId;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    if (this.course != null) {
      data['course'] = this.course.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pin_id'] = this.pinId;
    data['course_id'] = this.courseId;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }

  // get all subscriptions
  static Future<List<SubscriptionItem>> subscriptions() async {
    // Get a reference to the database.
    Future database = DB.initialize();
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query('subscriptions', orderBy: 'id');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      SubscriptionItem sub = SubscriptionItem.fromJson(maps[i]);
      return sub;
    });
  }

  void set setUser(User user) {
    this.user = user;
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.
    Future database = DB.initialize();
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.

    // store course first
    this.course.insertToDb();

    // then user
    this.user.insertToDb();

    // then store this guy in db
    await db.insert(
      'subscriptions',
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

