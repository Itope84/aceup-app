import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/add-subscription.dart';
import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/user.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/util/avatar.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:aceup/widgets/hint-button.dart';
import 'package:aceup/widgets/return-button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final MainModel model;
  final Function onCourseChange;
  ProfileScreen({this.model, this.onCourseChange});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _position;
  bool _loadingSub = false;
  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void getPosition() async {
    if (widget.model.activeCourseProfile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int pos = await prefs.getInt(
          "${widget.model.activeCourseProfile.course.id}leaderboardPosition");

      setState(() {
        _position = pos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: widget.model,
      child: Scaffold(
        body: ScopedModelDescendant<MainModel>(
          builder: (context, widget, model) => FutureBuilder(
            future: model.getUserFromDb(notify: false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                User user = snapshot.data;
                return Stack(
                  children: <Widget>[
                    Container(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 70.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Avatars.avatarFromId(user.avatarId,
                                    username: user.username),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  (user.firstName != null
                                          ? user.firstName
                                          : "") + " " +
                                      (user.lastName != null
                                          ? user.lastName
                                          : ""),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context).backgroundColor),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  user.username,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).backgroundColor),
                                ),
                              ],
                            ),
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Center(
                            child: Text(
                              "Active: " +
                                  model.activeCourseProfile.course.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
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
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    _position != null
                                        ? _position.toString()
                                        : "?",
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
                                color: Theme.of(context).accentColor,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Points",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    model.activeCourseProfile != null
                                        ? model.activeCourseProfile.points
                                            .toString()
                                        : "",
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
                          SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20, left: 30),
                            child: Text(
                              "Registered Courses",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: user.courseProfiles.map((profile) {
                              return activeCourseBanner(
                                  context, profile, model);
                            }).toList(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: BlockButton(
                                  child: Text("Add Subscription"),
                                  onPressed: () {
                                    setState(() {
                                      _loadingSub = true;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddSubscription(
                                                  onActivate: () async {
                                                    await model.getUserFromApi();
                                                    setState(() {
                                                      _loadingSub = false;
                                                    });
                                                  }),
                                          fullscreenDialog: true,
                                        ));
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    ReturnButton(onPressed: () {
                      Navigator.pop(context);
                    }),
                    HintButton()
                  ],
                );
              }
              return PageHolder(
                child: Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget activeCourseBanner(
      BuildContext context, CourseProfile profile, MainModel model) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(bottom: 30.0),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          profile.course.featuredImage)),
                ),
                height: 170,
              ),
            ),
            SizedBox(height: 7),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                profile.course.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 3),
          ],
        ),
        onTap: () {
          model.activeCourseProfile = profile;
          Navigator.pop(context);
        },
      ),
    );
  }
}
