import 'dart:convert';

import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/opponent-profile.dart';
import 'package:aceup/pages/json-classes/user.dart';
import 'package:aceup/util/avatar.dart';
import 'package:aceup/util/requests.dart';
import 'package:aceup/widgets/screen-title.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardScreen extends StatefulWidget {
  final MainModel model;
  LeaderboardScreen({this.model});
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<OpponentProfile> _profiles;
  int _currentPage;
  Course course;
  bool _loading;
  int _lastPage;
  int _position;
  User _user;

  void fetchLeaderboard({bool overwrite: false}) async {
    // Fetch user profile
    _user = await widget.model.getUserFromDb();

    // there's a bug where we scroll to the bottom and there's no item yet, at this pt, cpage is 0 and overwrite isn't set
    if (course == null || (!overwrite && _currentPage == 0)) return;
    Map<String, String> headers = await ApiRequest.headers();

    Response response = await get(
        ApiRequest.BASE_URL +
            '/courses/${course.id}/leaderboard' +
            (overwrite ? "" : "?page=${(_currentPage + 1).toString()}"),
        headers: headers);

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
        String res = response.body;
        Map<String, dynamic> data = json.decode(res);
        List<dynamic> jsonp = data['data'];
        int position = data['user_position'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("${course.id}leaderboardPosition", position);

        List<OpponentProfile> profiles = List.generate(jsonp.length, (i) {
          return OpponentProfile.fromJson(jsonp[i]);
        }).toList();

        if (this.mounted) {
          setState(() {
            _position = position;
            _profiles == null || overwrite
                ? _profiles = profiles
                : _profiles.addAll(profiles);
            _loading = false;
            _currentPage = data['meta']['current_page'];
            _lastPage = data['meta']['last_page'];
          });
        }
        break;
      case 401:
        // return to login
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _loading = false;
    course = widget.model.activeCourseProfile != null
        ? widget.model.activeCourseProfile.course
        : null;
    fetchLeaderboard(overwrite: true);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        try {
          await fetchLeaderboard(overwrite: true);
        } finally {}
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_loading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              _currentPage != _lastPage) {
            // start loading data
            setState(() {
              _loading = true;
            });
            fetchLeaderboard();
          }
          return null;
        },
        child: ListView(
          children: <Widget>[
            ScreenTitle("Leaderboard"),
            SizedBox(
              height: 30.0,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Avatars.avatarFromId(
                          (_user != null ? _user.avatarId : null),
                          width: 30.0),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        _user != null ? _user.username : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Rank",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            _position != null ? _position.toString() : "?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 40.0,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Container(
                        height: 50.0,
                        width: 1.0,
                        color: Colors.white,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Points",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            widget.model.activeCourseProfile.points.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 40.0,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Pos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                    child: Text("User",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                    child: Text("Pts",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              child: _profiles != null && _profiles.length > 0
                  ? ListView.builder(
                      itemCount: _profiles.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      itemBuilder: (context, index) {
                        return leaderBoardItem(index);
                      },
                    )
                  : Padding(
                      child: Center(child: CircularProgressIndicator()),
                      padding: EdgeInsets.all(30.0),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget leaderBoardItem(index) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Text((index + 1).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Avatars.avatarFromId(_profiles[index].avatarId,
                    username: _profiles[index].username, width: 25.0),
                SizedBox(
                  width: 5.0,
                ),
                Flexible(
                  child: Text(
                    _profiles[index].username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Text(_profiles[index].points.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
