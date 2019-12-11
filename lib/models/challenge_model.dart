import 'dart:convert';

import 'package:aceup/models/top_level_data_model.dart';
import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/opponent-profile.dart';
import 'package:aceup/util/requests.dart';
import 'package:http/http.dart';

abstract class ChallengeModel extends TopLevelDataModel {
  List<OpponentProfile> _profiles;
  int currentPage = 0;
  Map<String, dynamic> meta;

  List<OpponentProfile> get opponentProfiles {
    return _profiles;
  }

  Future<List<OpponentProfile>> fetchProfiles() async {
    Map<String, String> headers = await ApiRequest.headers();

    CourseProfile profile = activeCourseProfile != null ? activeCourseProfile : (await userProfile()).courseProfiles[0];

    Response response = await get(ApiRequest.BASE_URL + '/courses/${profile.courseId}/profiles' + meta['current_page'],
        headers: headers);

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
        String res = response.body;
        Map<String, dynamic> data = json.decode(res);
        List<dynamic> jsonp = data['data'];

        List<OpponentProfile> profiles = List.generate(jsonp.length, (i) {
          return OpponentProfile.fromJson(jsonp[i]);
        }).toList();

        return profiles;
        break;
      case 401:
        // return to login
        // break;
      default:
        return null;
        break;
    }
  }
}