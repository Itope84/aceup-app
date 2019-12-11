import 'dart:convert';

import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/challenges/select-opponent.dart';
import 'package:aceup/pages/challenges/start-challenge.dart';
import 'package:aceup/pages/json-classes/challenge.dart';
import 'package:aceup/util/avatar.dart';
import 'package:aceup/util/const.dart';
import 'package:aceup/util/requests.dart';
import 'package:aceup/widgets/screen-title.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengesScreen extends StatefulWidget {
  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List<Challenge> _challenges;
  bool _loading = false;
  int _lastPage;
  int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    fetchChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, widget, model) {
      return RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          try {
            await fetchChallenges(replace: true);
          } finally {}
        },
        child: Container(
          child: ListView(
            children: <Widget>[
              ScreenTitle("Challenges"),
              Container(
                padding: EdgeInsets.all(30.0),
                child: RaisedButton(
                  child: Text("Challenge Someone"),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) {
                        return SelectOpponent(
                          course: model.activeCourseProfile.course,
                        );
                      },
                    ));
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Constants.mainWhite,
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Recent Challenges",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              ),
              _challenges != null && _challenges.length > 0
                  ? challengesList()
                  : Padding(
                      child: Center(child: CircularProgressIndicator()),
                      padding: EdgeInsets.all(30.0),
                    ),
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
      );
    });
  }

  Widget challengesList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_loading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            _currentPage != _lastPage) {
          // start loading data
          setState(() {
            _loading = true;
          });
          fetchChallenges();
        }
        return null;
      },
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        child: ListView.builder(
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _challenges.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: singlePastChallenge(index),
            );
          },
        ),
      ),
    );
  }

  Widget singlePastChallenge(index) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: _challenges[index].scores.complete
                      ? Color.fromRGBO(30, 30, 30, 0.3)
                      : Colors.orange[200],
                  blurRadius: 0.3)
            ],
            color: Colors.white70),
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Avatars.avatarFromId(_challenges[index].challenger.avatarId,
                      width: 25.0),
                  Flexible(
                    child: Text(
                      _challenges[index].challenger.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              _challenges[index].scores.challenger.toString(),
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "-",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              _challenges[index].scores.opponent.toString(),
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      _challenges[index].opponent.username != null
                          ? _challenges[index].opponent.username
                          : "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Avatars.avatarFromId(_challenges[index].opponent.avatarId,
                      width: 25.0),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StartChallenge(challenge: _challenges[index]),
          ),
        );
      },
    );
  }

  Future<void> fetchChallenges({bool replace: false}) async {
    // Please let's be fetching all challenges from API, let's know what we're doing o
    Map<String, String> headers = await ApiRequest.headers();

    Response response = await get(
        ApiRequest.BASE_URL +
            '/challenges' +
            (replace ? "" : "?page=${(_currentPage + 1).toString()}"),
        headers: headers);

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
        String res = response.body;
        Map<String, dynamic> data = json.decode(res);
        List<dynamic> jsonp = data['data'];

        List<Challenge> challenges = List.generate(jsonp.length, (i) {
          return Challenge.fromJson(jsonp[i]);
        }).toList();

        if (this.mounted) {
          setState(() {
            _challenges == null || replace
                ? _challenges = challenges
                : _challenges.addAll(challenges);
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
}
