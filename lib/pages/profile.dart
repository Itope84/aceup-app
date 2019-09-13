import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/user.dart';
import 'package:aceup/pages/pageholder.dart';
import 'package:aceup/widgets/return-button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileScreen extends StatefulWidget {
  final MainModel model;
  final Function onCourseChange;
  ProfileScreen({this.model, this.onCourseChange});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                                Image.asset(
                                  'assets/avatars/001.png',
                                  width: 80.0,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  (user.firstName != null
                                          ? user.firstName
                                          : "") +
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
                            height: 30.0,
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
                                    "240",
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
                          )
                        ],
                      ),
                    ),
                    ReturnButton(onPressed: () {
                      Navigator.pop(context);
                    }),
                    Positioned(
                      top: 50,
                      width: 60.0,
                      right: 0.0,
                      child: RaisedButton(
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        color: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
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
