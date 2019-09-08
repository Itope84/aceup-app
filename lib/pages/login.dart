import 'dart:convert';
import 'package:aceup/pages/json-classes/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aceup/util/requests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import '../widgets/text-input.dart';
import '../util/const.dart';

class LoginScreen extends StatefulWidget {
  final Function loginHandler;
  final Function gotoSignup;

  LoginScreen({this.loginHandler, this.gotoSignup});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "", _password = "";
  bool _showPassword = false, _loading = false;

  _login() async {
    setState(() {
      _loading = true;
    });

    Map<String, String> data = {
      'email': _email,
      'password': _password,
    };

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await post(ApiRequest.BASE_URL + '/login',
        headers: headers, body: json.encode(data));

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        Map<String, dynamic> data = json.decode(response.body);
        User user = User.fromJson(data['data']);
        // store it in database
        user.insertToDb();

        if (data['token'] != null) {
          final storage = new FlutterSecureStorage();
          await storage.write(key: 'token', value: data['token']);
        }

        widget.loginHandler();
        break;
      case 422:
        Map<String, dynamic> data = json.decode(response.body);
        String msg = data['message'];
        Map errors = data['errors'];
        if (errors.values.toList().length > 0) {
          // show first error
          msg = errors.values.toList().first[0];
        }
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.redAccent);
        break;
      case 401:
        Toast.show("invalid login details!", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.redAccent);
        break;
      default:
        Toast.show("Sorry, an error occured!", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Constants.mainWhite,
      ),
      child: new ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 50.0),
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
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
          SizedBox(height: 40.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Email
              DefaultTextInput(
                label: "Email",
                type: TextInputType.emailAddress,
                placeholder: 'email@gmail.com',
                initialValue: _email,
                onChange: (val) {
                  setState(() {
                    _email = val;
                  });
                },
              ),
              SizedBox(
                height: 20.0,
              ),

              // password
              DefaultTextInput(
                label: "Password",
                type: TextInputType.text,
                placeholder: '******',
                obscureText: !_showPassword,
                suffixIcon: InkWell(
                  child: Icon(_showPassword ? MdiIcons.eyeOff : MdiIcons.eye),
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
                onChange: (val) {
                  setState(() {
                    _password = val;
                  });
                },
              ),

              SizedBox(
                height: 20.0,
              ),

              Container(
                  margin: const EdgeInsets.only(
                      left: 30.0, right: 30.0, bottom: 20.0, top: 40.0),
                  alignment: Alignment.center,
                  child: new Row(children: <Widget>[
                    new Expanded(
                      child: new RaisedButton(
                        elevation: 1.0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        color: Constants.mainPrimary,
                        disabledElevation: 0,
                        disabledColor: Color.alphaBlend(
                            Colors.white54, Theme.of(context).primaryColor),
                        onPressed:
                            (_email.isEmpty || _password.isEmpty || _loading)
                                ? null
                                : () async {
                                    try {
                                      await _login();
                                    } catch (_) {
                                      Toast.show(
                                          "Sorry, an error occured!", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM,
                                          backgroundColor: Colors.redAccent);
                                    } finally {
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  },
                        child: new Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 20.0,
                          ),
                          child: _loading
                              ? SizedBox(
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                  ),
                                  height: 20.0,
                                  width: 20.0,
                                )
                              : new Row(
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
                    )
                  ])),

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
                        "New here? Register instead",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                      onPressed: () {
                        widget.gotoSignup();
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
