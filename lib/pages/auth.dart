import 'package:flutter/material.dart';
import '../util/const.dart';

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

  Widget welcomePage() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: new ListView(
        children: <Widget>[
          // logo container
          Container(
            padding: EdgeInsets.only(top: 100.0),
            child: Center(
                child: Image.asset(
              "assets/aceup-circle-icon.png",
              width: 120.0,
            )),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "WELCOME",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "Let's get you started on your first subscription",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          new Container(
            margin: EdgeInsets.only(top: 40.0),
            child: Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.mainPrimary,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Constants.mainPrimary,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'awesomeuser@gmail.com',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
            color: Colors.transparent,
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "Pin",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Constants.mainPrimary,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Constants.mainPrimary,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '******',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
            color: Colors.transparent,
          ),

          // what's this
          Container(
            margin:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
            child: Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  textColor: Constants.mainPrimary,
                  splashColor: Constants.mainPrimary,
                  child: Text(
                    "What's this?",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Container(
            margin:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new RaisedButton(
                    elevation: 1.0,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: Constants.mainPrimary,
                    onPressed: () {
                      widget.loginHandler();
                    },
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "Activate",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 50.0),
            child: Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  textColor: Constants.mainPrimary,
                  splashColor: Constants.mainPrimaryLight,
                  child: Text(
                    "Already signed up somewhere else?",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeIn,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    // The auth page container
    return Container(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          controller: _controller,
          physics: new NeverScrollableScrollPhysics(),
          children: <Widget>[welcomePage()],
          scrollDirection: Axis.horizontal,
        ));
  }
}
