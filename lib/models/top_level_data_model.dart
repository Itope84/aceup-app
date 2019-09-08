import 'dart:convert';

import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/pages/json-classes/user.dart';
import 'package:aceup/util/requests.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopLevelDataModel extends Model {
  User _user;
  CourseProfile _activeCourseProfile;
  Topic _activeTopic;

  Future<User> get userProfile async {
    // if user is not nll, return user
    // else call on the function that gets it from local db
    if (_user == null) {
      /// get user from db but at the same time, call function that gets it from backend without awaiting that
      await getUserFromDb();

      try {
        getUserFromApi();
      } catch (_) {}
    }

    return _user;
  }

  // returns the user without any async nonsense
  get user {
    return _user;
  }

  Future<void> getUserFromDb() async {
    /// get user and course profiles, remeber to attach course profiles to user
    ///
    User user = (await User.users()).last;
    List<CourseProfile> courseProfiles =
        await CourseProfile.whereUserId(user.id);
    user.courseProfiles = courseProfiles;

    _user = user;
  }

  Future<void> getUserFromApi() async {
    // get user from api snd notify listeners when done
    Map<String, String> headers = await ApiRequest.headers();

    Response response =
        await get(ApiRequest.BASE_URL + '/profile', headers: headers);

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
        Map<String, dynamic> data = json.decode(response.body);
        User user = User.fromJson(data['data']);
        // No need to await this
        user.insertToDb();

        if (data['course_profiles'] != null) {
          List<CourseProfile> courseProfiles = new List<CourseProfile>();
          data['course_profiles'].forEach((v) {
            CourseProfile profile = new CourseProfile.fromJson(v);
            profile.insertToDb();
            profile.course.insertToDb();
            if (profile.course.activeTopic != null) {
              profile.course.activeTopic.insertToDb();
            }
            courseProfiles.add(profile);
          });
          user.courseProfiles = courseProfiles;
        }

        _user = user;

        notifyListeners();
        break;

      case 401:
      // return to login page

      default:
        break;
    }
  }

  get activeCourseProfile {
    return _activeCourseProfile;
  }

  Future<CourseProfile> getActiveCourseProfileFromDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("activeCourseProfileId");
    CourseProfile profile;
    if (id != null) {
      profile = await CourseProfile.whereId(id);
      // todo: change this
      profile.course.activeTopic = await Topic.firstTopic(profile.course.id);
    } else if (_user != null && _user.courseProfiles.length > 0) {
      profile = _user.courseProfiles[0];
    } else {
      // gotta be first time in
      User user = await userProfile;
      profile = user.courseProfiles.length > 0 ? user.courseProfiles[0] : null;
      profile.course = await Course.whereId(profile.courseId);
      // Todo: change this
      profile.course.activeTopic = await Topic.firstTopic(profile.course.id);
    }

    _activeCourseProfile = profile;

    notifyListeners();
    return profile;
  }

  set activeCourseProfile(CourseProfile profile) {
    // Async task, but don't await it
    storeActiveCourseProfile(profile);
    _activeCourseProfile = profile;
    notifyListeners();
  }

  void storeActiveCourseProfile(CourseProfile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("activeCourseProfileId", profile.id);
  }

  get activeTopic {
    return _activeTopic;
  }

  Future<Topic> getActiveTopicFromDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    CourseProfile profile = activeCourseProfile != null ? activeCourseProfile : await getActiveCourseProfileFromDb();

    int id = prefs.getInt("course${profile.courseId}activeTopicId");
    Topic topic;

    if (id != null) {
      topic = await Topic.whereId(id);
    }

    if (topic == null) {
      topic = profile != null ? profile.course.activeTopic : null;
      if (topic != null) {
        topic.course = await Course.whereId(topic.courseId);
      }
    }

    _activeTopic = topic;

    notifyListeners();
    return topic;
  }

  set activeTopic(Topic topic) {
    // Async task, but don't await it
    storeActiveTopicId(topic);
    _activeTopic = topic;
    notifyListeners();
  }

  void storeActiveTopicId(Topic topic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("course${topic.courseId}activeTopicId", topic.id);
  }
}
