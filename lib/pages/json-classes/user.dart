import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/util/database.dart';
import 'package:sqflite/sqlite_api.dart';

class User {
  int id;
  String email;
  String firstName;
  String lastName;
  int departmentId;
  String gender;
  String username;
  String createdAt;
  String updatedAt;
  int avatarId;
  String role;
  List<CourseProfile> courseProfiles;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.departmentId,
      this.gender,
      this.username,
      this.createdAt,
      this.updatedAt,
      this.avatarId,
      this.role, this.courseProfiles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    departmentId = json['department_id'];
    gender = json['gender'];
    username = json['username'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    avatarId = json['avatar_id'] is String ? int.parse(json['avatar_id']) : json['avatar_id'];
    role = json['role'];
    if (json['course_profiles'] != null) {
      courseProfiles = new List<CourseProfile>();
      json['course_profiles'].forEach((v) {
        courseProfiles.add(new CourseProfile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['department_id'] = this.departmentId;
    data['gender'] = this.gender;
    data['username'] = this.username;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['avatar_id'] = this.avatarId;
    data['role'] = this.role;
    return data;
  }

  Future<void> insertToDb() async {
    // Get a reference to the database.

    Future database = DB.initialize();
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'users',
      this.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<User>> users() async {
    // Get a reference to the database.
    Future database = DB.initialize();
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query('users', orderBy: 'id');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      User user = User.fromJson(maps[i]);
      return user;
    });
  }

  static Future<User> whereId(int id) async {
    Future database = DB.initialize();
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: "id = ?",
      whereArgs: [id]
    );
    Map<String, dynamic> user = result.length == 0 ? null : result[0];
    return user != null ? User.fromJson(user) : user;
  }
}
