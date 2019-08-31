import 'package:flutter/material.dart';

import '../util/const.dart';

class LoginScreen extends StatefulWidget {
  final Function loginHandler;
  final Function gotoSignup;

  LoginScreen({this.loginHandler, this.gotoSignup});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget label(String text) {
    return Constants.defaultInputLabel(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Constants.mainWhite,
        ),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 50.0),
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                    child: Text(
                      "Sign in",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Email
                      Constants.defaultInputWidget(
                          label: "Email",
                          type: TextInputType.emailAddress,
                          placeholder: 'email@gmail.com',
                          controller: TextEditingController(text: "")),

                      Divider(
                        height: 20.0,
                        color: Colors.transparent,
                      ),
                      
                      Constants.defaultInputWidget(
                          label: "Password",
                          placeholder: '*******',
                          controller: TextEditingController(text: null)),

                      Divider(
                        height: 20.0,
                        color: Colors.transparent,
                      ),

                      Container(
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, bottom: 20.0, top: 40.0),
                        alignment: Alignment.center,
                        child: new RaisedButton(
                          elevation: 1.0,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
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
                                    "Sign In",
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

                      Container(
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, bottom: 50.0),
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            FlatButton(
                              textColor: Constants.mainPrimary,
                              splashColor: Constants.mainPrimaryLight,
                              child: Text(
                                "Don't have an account yet? Register Now",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.0,
                                ),
                              ),
                              onPressed: () {
                                widget.gotoSignup("");
                              },
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]));
  }
}
