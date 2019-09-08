import 'package:aceup/models/top_level_data_model.dart';
import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/util/const.dart';
import 'package:aceup/widgets/screen-title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'details.dart';

class Home extends StatefulWidget {
  final Function gotoPage;

  Home({this.gotoPage});
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  // final TextEditingController _searchControl = new TextEditingController();

  Widget activeTopic(CourseProfile profile) {
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
                          profile.course.activeTopic != null ? profile.course.activeTopic.title : "",
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
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Details();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ScreenTitle("Continue Learning"),

          // Latest topic
          ScopedModelDescendant<TopLevelDataModel>(
            builder: (context, widget, model) {
              return model.activeCourseProfile == null
                  ? FutureBuilder(
                      future: model.getActiveCourseProfileFromDb(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return placeholderCard(
                                child: Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),
                              ),
                            ));
                          case ConnectionState.done:
                            return activeTopic(snapshot.data);

                          default:
                            return placeholderCard(
                              child: Center(
                                child: Text("An error occured"),
                              ),
                            );
                        }
                      },
                    )
                  : activeTopic(model.activeCourseProfile);
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
                        child: Column(
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text("User",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                    child: Text("Pts",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Text("2",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/avatars/001.png',
                                          width: 25.0,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Santiago",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text("40",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Text("2",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/avatars/001.png',
                                          width: 25.0,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Santiago",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text("40",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: Text("2",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/avatars/001.png',
                                          width: 25.0,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          "Santiago",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text("40",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 7),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Details();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
