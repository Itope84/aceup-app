import 'package:aceup/models/main_model.dart';
import 'package:aceup/pages/challenges.dart';
import 'package:aceup/pages/hints.dart';
import 'package:aceup/pages/json-classes/course-profile.dart';
import 'package:aceup/pages/json-classes/quiz.dart';
import 'package:aceup/pages/json-classes/user.dart';
// import 'package:aceup/pages/eq_demo.dart';
import 'package:aceup/pages/leaderboard.dart';
import 'package:aceup/pages/playground.dart';
import 'package:aceup/pages/profile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home.dart';
import 'learn.dart';
import '../widgets/icon_badge.dart';

class MainScreen extends StatefulWidget {
  // final changeThemeHandler;

  // MainScreen(this.changeThemeHandler);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  Future<User> _userProfile;
  int _page = 0;

  int _status = 0;

  MainModel _model = new MainModel();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userProfile = _model.userProfile();
  }

  Future<void> tryFetchData() async {
    // try submitting unsubmitted
    setState(() {
      _status = 1;
    });
    List<Quiz> quizzes = await Quiz.whereNotSubmitted();

    if (quizzes.length > 0) {
      await _model.submitQuizzes();
    }

    List<CourseProfile> profiles = (await _userProfile).courseProfiles;

    for (CourseProfile profile in profiles) {
      await _model.topics(profile.course.id);
      await _model.fetchContent(profile);
    }

    // not using setstate cause that triggers a refetch
    _status = 0;
  }

  goToPage(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    if (_status != 1) {
      tryFetchData();
    }

    Widget bottomBarIcon(
        {IconData icon = Icons.home, int page = 0, bool badge = false}) {
      return IconButton(
        icon: badge ? IconBadge(icon: icon, size: 24) : Icon(icon, size: 24),
        color: _page == page
            ? Theme.of(context).primaryColor
            : Theme.of(context).accentColor,
        onPressed: () => _pageController.jumpToPage(page),
      );
    }

    return ScopedModel<MainModel>(
      model: _model,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ProfileScreen(
                    model: _model,
                    onCourseChange: () {
                      goToPage(1);
                    },
                  );
                }));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.lightbulb_outline,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Hint(),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100.0,
                child: DrawerHeader(
                  child: Text(
                    'Change Active Course',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor),
                  ),
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      ),
                ),
              ),
              ScopedModelDescendant<MainModel>(
                builder: (context, widget, model) {
                  return FutureBuilder(
                    future: model.userProfile(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text(
                            "No internet connection",
                            textAlign: TextAlign.center,
                          );
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text(
                              "Error:${snapshot.error}",
                              textAlign: TextAlign.center,
                            );
                          }

                          if (!snapshot.hasData) {
                            return Text("Nothing here at the moment");
                          }

                          User user = snapshot.data;

                          return Container(
                            child: Column(
                              children: user.courseProfiles
                                  .map((profile) => Container(
                                        child: ListTile(
                                          title: Text(
                                            profile.course != null
                                                ? profile.course.title
                                                : "",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                                color: model.activeCourseProfile !=
                                                            null &&
                                                        profile.id ==
                                                            model
                                                                .activeCourseProfile
                                                                .id
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .accentColor),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          onTap: () {
                                            // Update the state of the app.
                                            model.activeCourseProfile = profile;
                                            goToPage(_page == 1 ? 0 : 1);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        color: model.activeCourseProfile !=
                                                    null &&
                                                profile.id ==
                                                    model.activeCourseProfile.id
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent,
                                      ))
                                  .toList(),
                            ),
                          );
                        default:
                          return Text("Nothing here at the moment");
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
        body: PageView(
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Home(
              model: _model,
              gotoPage: (int page) {
                goToPage(page);
              },
            ),
            Learn(model: _model),
            Playground(
              model: _model,
            ),
            ChallengesScreen(),
            LeaderboardScreen(model: _model),
            // EqDemo()
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 7),
              bottomBarIcon(icon: Icons.home, page: 0),
              bottomBarIcon(icon: MdiIcons.bookOpenPageVariant, page: 1),
              bottomBarIcon(icon: MdiIcons.gamepadVariant, page: 2),
              bottomBarIcon(icon: MdiIcons.medal, page: 3),
              bottomBarIcon(icon: MdiIcons.podium, page: 4),
              SizedBox(width: 7),
            ],
          ),
          color: Theme.of(context).backgroundColor,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
