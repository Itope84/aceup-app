import 'dart:convert';

import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/opponent-profile.dart';
import 'package:aceup/pages/topic/slides.dart';
import 'package:aceup/util/avatar.dart';
import 'package:aceup/util/const.dart';
import 'package:aceup/util/requests.dart';
import 'package:aceup/widgets/screen-title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class Home extends StatefulWidget {
  final Function gotoPage;
  final MainModel model;
  Home({this.gotoPage, this.model});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final TextEditingController _searchControl = new TextEditingController();
  MainModel _model;
  Future<CourseProfile> activeCourseProfile;
  CourseProfile _activeCourseProfile;
  bool _loadingProfile = true;
  bool _loadingLeaderboard = true;
  List<OpponentProfile> _leaderboard;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
    getActiveCourseProfile();
    getLeaderboard();
  }

  Future<void> getLeaderboard() async {
    if (_activeCourseProfile == null) {
      return;
    }

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await get(
        ApiRequest.BASE_URL +
            '/courses/${_activeCourseProfile.course.id}/leaderboard/abbreviated',
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

        if (this.mounted) {
          setState(() {
            _leaderboard = profiles;
            _loadingLeaderboard = false;
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

  Future<void> getActiveCourseProfile() async {
    if (_model.activeCourseProfile == null) {
      await _model.userProfile();
    }
    CourseProfile profile = _model.activeCourseProfile == null ||
            _model.activeCourseProfile.course.activeTopic == null
        ? await _model.getActiveCourseProfileFromDb()
        : _model.activeCourseProfile;

    if (this.mounted) {
      setState(() {
        _activeCourseProfile = profile;
        _loadingProfile = false;
      });
    }

    try {
      await getLeaderboard();
    } finally {
      if (this.mounted) {
        setState(() {
          _loadingLeaderboard = false;
        });
      }
    }
  }

  Widget activeTopic(CourseProfile profile, MainModel model) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      margin: EdgeInsets.only(bottom: 30.0),
      child: InkWell(
        child: Container(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          profile.course.featuredImage,
                        )),
                  ),
                  height: 170,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.5),
                            Colors.transparent
                          ]),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          profile.course.activeTopic != null
                              ? profile.course.activeTopic.title
                              : "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                alignment: Alignment.centerLeft,
                child: Text(
                  profile.course.title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 3),
            ],
          ),
        ),
        onTap: profile.course == null || profile.course.activeTopic == null
            ? null
            : () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SlideContainer(topic: profile.course.activeTopic);
                    },
                  ),
                );
              },
      ),
    );
  }

  Widget placeholderCard({Widget child}) {
    return Container(
        height: 200.0,
        margin:
            EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0, top: 20.0),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(30, 30, 30, 0.3), blurRadius: 0.3)
            ],
            color: Constants.mainWhite),
        child: child);
  }

  Widget abbreviatedLeaderboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
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
                flex: 3,
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
        Column(
          children: _leaderboard
              .asMap()
              .map(
                (index, profile) => MapEntry(
                  index,
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                            child: Icon(
                          index == 0
                              ? Icons.arrow_drop_up
                              : index == 1
                                  ? MdiIcons.minus
                                  : Icons.arrow_drop_down,
                          color: index == 0
                              ? Theme.of(context).primaryColor
                              : index == 1
                                  ? Theme.of(context).accentColor
                                  : Colors.red,
                        )),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Avatars.avatarFromId(profile.avatarId,
                                  width: 25.0, margin: 0),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                profile.username,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(profile.points.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ScreenTitle("Continue Learning"),

          // Latest topic
          ScopedModelDescendant<MainModel>(
            builder: (context, widget, model) {
              return _activeCourseProfile != null
                  ? activeTopic(_activeCourseProfile, model)
                  : _loadingProfile
                      ? placeholderCard(
                          child: Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : placeholderCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: Icon(
                                  MdiIcons.alertCircle,
                                  size: 50.0,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Text(
                                "You need internet to load the app the first time.",
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        );
            },
          ),

          // Playground
          // Latest topic
          Container(
            padding: EdgeInsets.only(top: 10, left: 20),
            margin: EdgeInsets.only(bottom: 30.0),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/playground.png")),
                          ),
                          height: 170,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, 0.5),
                                    Colors.transparent
                                  ]),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Playground",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                    ],
                  ),
                ),
                onTap: () {
                  widget.gotoPage(2);
                },
              ),
            ),
          ),

          Center(
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 0),
              margin: EdgeInsets.only(bottom: 0.0),
              width: MediaQuery.of(context).size.width * 0.85,
              child: Text(
                "Leaderboard",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor,
                    fontSize: 20.0),
              ),
            ),
          ),

          // leaderboard
          Container(
            padding: EdgeInsets.only(top: 10, left: 20),
            margin: EdgeInsets.only(bottom: 30.0),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(30, 30, 30, 0.3),
                                  blurRadius: 0.3)
                            ],
                            color: Constants.mainWhite),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: _leaderboard != null
                            ? abbreviatedLeaderboard()
                            : _loadingLeaderboard
                                ? Center(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: Text(
                                          "Could not fetch Leaderboard data"),
                                    ),
                                  ),
                      ),
                      SizedBox(height: 7),
                    ],
                  ),
                ),
                onTap: () {
                  widget.gotoPage(4);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
