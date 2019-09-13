import 'dart:convert';

import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/slide.dart';
import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/pages/json-classes/user.dart';
import 'package:aceup/util/requests.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopLevelDataModel extends Model {
  User _user;
  CourseProfile _activeCourseProfile;

  Future<User> userProfile() async {
    // if user is not null, that's all we need
    if (_user == null ||
        _user.courseProfiles == null ||
        _user.courseProfiles.length < 1) {
      await getUserFromDb();
      // if still null, go to the api
      if (_user.courseProfiles == null || _user.courseProfiles.length < 1) {
        await getUserFromApi();
      } else {
        // still get from api, but async
        getUserFromApi();
      }
    }

    return _user;
  }

  // sorry, but I gotta do this out here

  Future<User> getUserFromDb({bool notify: true}) async {
    User user = (await User.users()).last;

    // Get the user's course profiles too
    List<CourseProfile> courseProfiles =
        await CourseProfile.whereUserId(user.id);
    user.courseProfiles = courseProfiles;

    _user = user;

    if (user.courseProfiles.length > 0) {
      _activeCourseProfile = user.courseProfiles.firstWhere((profile) =>
          _activeCourseProfile != null
              ? profile.id == _activeCourseProfile.id
              : true);
    }

    if (notify) notifyListeners();

    return user;
  }

  Future<User> getUserFromApi() async {
    // get user from api snd notify listeners when done
    Map<String, String> headers = await ApiRequest.headers();

    Response response =
        await get(ApiRequest.BASE_URL + '/profile', headers: headers);

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
        String res = response.body;
        Map<String, dynamic> data = json.decode(res);
        User user = User.fromJson(data['data']);
        // No need to await this
        user.insertToDb();

        if (data['course_profiles'] != null) {
          List<CourseProfile> courseProfiles = new List<CourseProfile>();
          await data['course_profiles'].forEach((v) async {
            CourseProfile profile = new CourseProfile.fromJson(v);
            await profile.insertToDb();
            await profile.course.insertToDb();
            if (profile.course.activeTopic != null) {
              profile.course.activeTopic.insertToDb();
            }
            courseProfiles.add(profile);
          });
          user.courseProfiles = courseProfiles;
        }

        _user = user;

        notifyListeners();
        return user;

      case 401:
      // return to login page

      default:
        break;
    }

    return null;
  }

  CourseProfile get activeCourseProfile {
    return _activeCourseProfile;
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

  Future<CourseProfile> getActiveCourseProfileFromDb() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("activeCourseProfileId");
    CourseProfile profile;

    if (id != null) {
      profile = await CourseProfile.whereId(id);

      profile.course.activeTopic = await getActiveTopicFromDb(profile.course);
    } else if (_user != null && _user.courseProfiles.length > 0) {
      profile = _user.courseProfiles[0];
    } else {
      // firstr time in, fetch the user
      User user = await userProfile();
      profile = user.courseProfiles.length > 0 ? user.courseProfiles[0] : null;
      if (profile != null) {
        profile.course = await Course.whereId(profile.courseId);
        // TODO: Change this
        profile.course.activeTopic = await Topic.firstTopic(profile.course.id);
      }
    }
    _activeCourseProfile = profile;

    notifyListeners();

    return profile;
  }

  Future<Topic> getActiveTopicFromDb(Course course) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("course${course.id}activeTopicId");

    if (id != null) {
      Topic topic = await Topic.whereId(id);
      return topic;
    }

    return await Topic.firstTopic(course.id);
  }

  void storeActiveTopicId(Topic topic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("course${topic.courseId}activeTopicId", topic.id);

    _activeCourseProfile.course.activeTopic = topic;
    notifyListeners();
  }

  Future<int> getLastSlideIndex(Topic topic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("topic${topic.id}activeSlideIndex");

    return id;
  }

  void storeLastSlide(int index, int topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("topic${topicId}activeSlideIndex", index);
  }
}
