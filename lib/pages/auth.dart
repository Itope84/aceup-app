import 'package:aceup/pages/json-classes/subscription-item.dart';
import 'package:aceup/pages/json-classes/user.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';
import 'welcome.dart';

class AuthScreen extends StatefulWidget {
  final loginHandler;
  AuthScreen({this.loginHandler});
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int initialPage;
  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);
  User _user;

  Future<SubscriptionItem> getLatestSub() async {
    List<SubscriptionItem> subs = await SubscriptionItem.subscriptions();

    if (subs.length > 0) {
      SubscriptionItem sub = subs.last;
      // fetch user
      User user = await User.whereId(sub.userId);
      sub.setUser = user;

      return sub;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  activate(user) {
    // Head to signup page with the provided email
    gotoSignup(user: user);
  }

  login() {
    widget.loginHandler();
  }

  gotoSignup({User user}) {
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    // The auth page container
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else {
            SubscriptionItem sub = snapshot.data;
            User user = _user;

            if (sub == null) {
              // leave it on this page
            } else if (sub.user == null || sub.user.username == null) {
              if (sub.user != null) user = sub.user;
              gotoSignup();
            } else {
              gotoLogin();
            }
            return Container(
              height: MediaQuery.of(context).size.height,
              child: PageView(
                controller: _controller,
                physics: new NeverScrollableScrollPhysics(),
                children: <Widget>[
                  WelcomeScreen(
                    onActivate: activate,
                  ),
                  SignupScreen(
                      user: user,
                      signupHandler: widget.loginHandler,
                      gotoLogin: gotoLogin),
                  LoginScreen(
                    loginHandler: widget.loginHandler,
                    gotoSignup: gotoSignup,
                  )
                ],
                scrollDirection: Axis.horizontal,
              ),
            );
          }
        },
        future: getLatestSub());
  }
}
