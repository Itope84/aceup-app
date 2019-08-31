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
  @override
  void initState() {
    super.initState();
  }

  PageController _controller =
      new PageController(initialPage: 0, viewportFraction: 1.0);

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  activate() {
    // send api request and head to signup
    gotoSignup("topephysics@gmail.com");
  }

  login() {
    widget.loginHandler();
  }

  gotoSignup(String inputEmail) {
    // axios request to check if the user account already exits for the email, if so head toi login else do below
    setState(() {
      email = inputEmail;
    });
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  String email;

  @override
  Widget build(BuildContext context) {
    // The auth page container
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
              email: email,
              signupHandler: widget.loginHandler,
              gotoLogin: gotoLogin
            ),
            LoginScreen(loginHandler: widget.loginHandler, gotoSignup: gotoSignup,)
          ],
          scrollDirection: Axis.horizontal,
        ));
  }
}
