import 'dart:convert';

import 'package:aceup/pages/json-classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import '../util/const.dart';
import '../util/requests.dart';
import '../widgets/text-input.dart';

class SignupScreen extends StatefulWidget {
  final User user;
  final Function signupHandler;
  final Function gotoLogin;

  SignupScreen({this.user, this.signupHandler, this.gotoLogin});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _loading = false;
  String _email = "",
      _password = "",
      _username = "",
      _firstname = "",
      _lastname = "",
      _phone = "";
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _email = widget.user != null ? widget.user.email : "";
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Constants.mainWhite,
      ),
      child: new ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                child: Text(
                  "Great work! Just a few more details",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          Container(
            padding: EdgeInsets.only(left: 40.0, bottom: 40.0),
            child: Text(
              "Your sign-in details",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                color: Constants.mainPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Email
          DefaultTextInput(
            label: "Email",
            disabled: _email != null && _email.length != 0,
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

          //  username
          DefaultTextInput(
            label: "Username",
            onChange: (val) {
              setState(() {
                _username = val;
              });
            },
            capitalize: true,
            type: TextInputType.text,
            placeholder: 'Awesomedude091',
          ),

          SizedBox(height: 20.0),

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
            height: 10.0,
          ),

          // Optional Text
          new Container(
            margin: EdgeInsets.only(bottom: 30.0, top: 15.0),
            child: new Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: new Text(
                "Optional",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(244, 16, 16, 1),
                  fontSize: 15.0,
                ),
              ),
            ),
          ),

          // Firstname
          DefaultTextInput(
            label: "First Name",
            type: TextInputType.text,
            placeholder: "John",
            capitalize: true,
            onChange: (val) {
              setState(() {
                _firstname = val;
              });
            },
          ),

          SizedBox(
            height: 20.0,
          ),

          DefaultTextInput(
            label: "Last Name",
            type: TextInputType.text,
            placeholder: "Doe",
            capitalize: true,
            onChange: (val) {
              setState(() {
                _lastname = val;
              });
            },
          ),

          SizedBox(
            height: 20.0,
          ),

          // Phone number
          DefaultTextInput(
            label: "Phone Number",
            type: TextInputType.phone,
            placeholder: '08181634383',
            onChange: (val) {
              setState(() {
                _phone = val;
              });
            },
          ),

          SizedBox(
            height: 20.0,
          ),

          // Signup button
          Container(
            margin: const EdgeInsets.only(
                left: 30.0, right: 30.0, bottom: 20.0, top: 20.0),
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
                  onPressed: (_email.isEmpty ||
                          _password.isEmpty ||
                          _username.isEmpty ||
                          _loading)
                      ? null
                      : () async {
                          try {
                            await _signup();
                          } catch (_) {
                            Toast.show("Sorry, an error occured!", context,
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
                                  "Register",
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
            ]),
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
                    "Already registered? Sign in instead",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    widget.gotoLogin();
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _signup() async {
    setState(() {
      _loading = true;
    });

    Map<String, String> data = {
      'email': _email,
      'password': _password,
      'username': _username,
      'first_name': _firstname != null ? _firstname : '',
      'last_name': _lastname != null ? _lastname : '',
      'phone': _phone != null ? _phone : ''
    };

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await post(ApiRequest.BASE_URL + '/users/profile',
        headers: headers, body: json.encode(data));

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        Map<String, dynamic> data = json.decode(response.body);

        // just in case the user closes the app after this page, we still wanna record this so we don't show them this screen anymore.

        User user = User.fromJson(data['data']);
        // store it in database
        user.insertToDb();
        // store token
        if (data['token'] != null) {
          final storage = new FlutterSecureStorage();
          await storage.write(key: 'token', value: data['token']);
        }

        widget.signupHandler();
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
      default:
        Toast.show("Sorry, an error occured!", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.redAccent);
    }
  }
}
