import 'dart:convert';

import 'package:toast/toast.dart';
import 'package:aceup/pages/challenges/start-challenge.dart';
import 'package:aceup/pages/json-classes/challenge.dart';
import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/opponent-profile.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/util/avatar.dart';
import 'package:aceup/util/const.dart';
import 'package:aceup/util/requests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SelectOpponent extends StatefulWidget {
  final Course course;
  SelectOpponent({this.course});
  @override
  _SelectOpponentState createState() => _SelectOpponentState();
}

class _SelectOpponentState extends State<SelectOpponent> {
  int _lastPage;
  int _currentPage;
  List<OpponentProfile> _profiles;
  bool _loading = false;
  int _opponent;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    // fetchProfiles(widget.course);
    fetchProfiles(widget.course);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageHolder(
        title: "Challenge Someone",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 80),
            searchBox(),
            _profiles == null
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!_loading &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              _currentPage != _lastPage) {
                            // start loading data
                            setState(() {
                              _loading = true;
                            });
                            fetchProfiles(widget.course);
                          }
                          return null;
                        },
                        child: GridView.builder(
                          itemCount: _profiles.length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return new FlatButton(
                              child: Column(
                                children: <Widget>[
                                  _opponent == _profiles[index].userId
                                      ? Container(
                                          margin: EdgeInsets.all(13),
                                          width: 80.0,
                                          height: 80.0,
                                          decoration: new BoxDecoration(
                                            color: Constants.mainPrimaryLight,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : Avatars.avatarFromId(
                                          _profiles[index].avatarId,
                                          username: _profiles[index].username),
                                  Text(
                                    _profiles[index].username,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                              onPressed: () {
                                try {
                                  challengeOpponent(_profiles[index].userId);
                                } finally {}
                              },
                            );
                          },
                        ))),
            Container(
              height: _loading ? 30.0 : 0,
              color: Colors.transparent,
              child: Center(
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: new CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          challengeOpponent(0);
        },
        child: _opponent == 0
            ? CircularProgressIndicator()
            : Icon(MdiIcons.shuffleVariant),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void fetchProfiles(course, {String search}) async {
    setState(() {
      _searching = true;
    });
    Map<String, String> headers = await ApiRequest.headers();
    String url = ApiRequest.BASE_URL +
        '/courses/${course.id}/profiles?' +
        (search == null ? "page=${(_currentPage + 1).toString()}" : "") +
        (search != null ? "&search=$search" : "");
    
    Response response = await get(url, headers: headers);

    int statusCode = response.statusCode;
    
    switch (statusCode) {
      case 200:
        String res = response.body;
        Map<String, dynamic> data = json.decode(res);
        List<dynamic> jsonp = data['data'];

        List<OpponentProfile> profiles = List.generate(jsonp.length, (i) {
          return OpponentProfile.fromJson(jsonp[i]);
        }).toList();

        setState(() {
          _profiles == null || search != null
              ? _profiles = profiles
              : _profiles.addAll(profiles);
          _loading = false;
          _searching = false;
          _currentPage = data['meta']['current_page'];
          _lastPage = data['meta']['last_page'];
        });
        break;
      case 401:
        // return to login
        break;
      default:
        break;
    }

    setState(() {
      _searching = false;
    });
  }

  Widget searchBox() {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 40, right: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (String val) =>
              fetchProfiles(widget.course, search: val),
          onChanged: (String val) => fetchProfiles(widget.course, search: val),
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.blueGrey[300],
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "Search friend's username",
            prefixIcon: Icon(
              Icons.search,
              color: Colors.blueGrey[300],
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.blueGrey[300],
            ),
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  /// Challenge a userId, 0 represents random
  Future<void> challengeOpponent(int opponentId) async {
    setState(() {
      _opponent = opponentId;
    });
    Map<String, dynamic> data = {
      'course_id': widget.course.id,
      'opponent': opponentId
    };

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await post(ApiRequest.BASE_URL + '/challenges/initiate',
        headers: headers, body: json.encode(data));

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        Map<String, dynamic> data = json.decode(response.body);

        // just in case the user closes the app after this page, we still wanna record this so we don't show them this screen anymore.

        Challenge challenge = Challenge.fromJson(data['data']);
        // store it in database
        challenge.insertToDb();

        setState(() {
          _opponent = null;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StartChallenge(challenge: challenge),
          ),
        );

        break;

      default:
        Toast.show("Sorry, an error occured!", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.redAccent);
    }
  }
}
