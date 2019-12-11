import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/course.dart';
import 'package:aceup/pages/json-classes/topic.dart';
import 'package:aceup/pages/quiz/sbt.dart';
import 'package:aceup/pages/topic/introduction.dart';
import 'package:aceup/util/const.dart';
import 'package:aceup/widgets/screen-title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'details.dart';

class Learn extends StatefulWidget {
  final String customTitle;
  final bool isSbt;
  final Model model;

  Learn({this.customTitle, this.isSbt: false, this.model});

  @override
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  String customTitle;
  bool isSbt;
  MainModel _model;
  // Future<List<Topic>> topics;
  List<Topic> _topics;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
    customTitle = widget.customTitle;
    isSbt = widget.isSbt;
    _model = widget.model;
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    CourseProfile profile = _model.activeCourseProfile;
    if (profile == null) {
      await _model.userProfile();
      profile = await _model.getActiveCourseProfileFromDb();
    }

    List<Topic> topics;
    if (profile != null) {
      topics = await _model.topics(profile.course.id);
      if (topics == null || topics.length < 2) {
        topics = await _model.getTopicsFromApi(profile.course.id);
      }
    }

    setState(() {
      _topics = topics;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _model != null
        ? ScopedModel<MainModel>(
            model: _model,
            child: Scaffold(appBar: isSbt ? AppBar() : null, body: body()),
          )
        : Scaffold(body: body());
  }

  Widget body() {
    return ScopedModelDescendant<MainModel>(
      builder: (context, widget, model) {
        return _topics != null
            ? RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () async {
                  try {
                    await model
                        .getTopicsFromApi(model.activeCourseProfile.course.id);
                  } finally {}
                },
                child: ListView(
                  children: <Widget>[
                    ScreenTitle(customTitle != null ? customTitle : "Learn"),

                    // Course Banner
                    Container(
                      padding:
                          EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                      margin: EdgeInsets.only(bottom: 30.0),
                      alignment: Alignment.center,
                      child: activeCourseBanner(
                          context, model.activeCourseProfile.course),
                    ),

                    // Body of the page
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Learn",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).accentColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    topicList(
                        _topics,
                        model.activeCourseProfile.course.activeTopic != null
                            ? model.activeCourseProfile.course.activeTopic.id
                            : null,
                        model),
                  ],
                ),
              )
            : _loading
                ? RefreshIndicator(
                    color: Theme.of(context).primaryColor,
                    onRefresh: () async {
                      try {
                        await model.getTopicsFromApi(
                            model.activeCourseProfile.course.id);
                      } finally {}
                    },
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : errorHolder(context);
      },
    );
  }

  Widget errorHolder(context) {
    return ListView(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 150,
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: Icon(
                  MdiIcons.alertCircle,
                  size: 100.0,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Something went wrong. \n Please check your internet and pull down to refresh",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "If this continues, please contact us",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget activeCourseBanner(BuildContext context, Course course) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(course.featuredImage)),
              ),
              height: 170,
            ),
          ),
          SizedBox(height: 7),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              course.title,
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
    );
  }

  Widget topicList(List<Topic> topics, int activeTopicId, MainModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: topics.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InkWell(
              child: Container(
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          topics[index].index.toString(),
                          style: TextStyle(
                              color: Constants.mainWhite,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      width: 50.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: topics[index].id == activeTopicId
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: topics[index].id == activeTopicId
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                          ),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              topics[index].title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0, color: Constants.mainWhite),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              onTap: () {
                model.storeActiveTopicId(topics[index]);
                model.getSlidesAndQuestionsFromApi(topics[index]);

                if (isSbt) {
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) {
                      return SolveByTopic(
                        topic: topics[index],
                      );
                    },
                  ));
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Introduction(
                            topic: topics[index],
                          );
                        },
                        settings: RouteSettings(name: 'introduction')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
