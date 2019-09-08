import 'dart:convert';

import 'package:aceup/pages/json-classes/subscription-item.dart';
import 'package:aceup/util/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import '../util/const.dart';

class WelcomeScreen extends StatefulWidget {
  final Function onActivate;
  WelcomeScreen({this.onActivate});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _email = "", _pin = "";
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Constants.mainWhite,
      ),
      child: new ListView(
        children: <Widget>[
          // logo container
          Container(
            padding: EdgeInsets.only(top: 60.0),
            child: Center(
                child: Image.asset(
              "assets/aceup-circle-icon.png",
              width: 80.0,
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
              "Let's activate your first subscription",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
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
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
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
                    onChanged: (str) {
                      setState(() {
                        _email = str;
                      });
                    },
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.emailAddress,
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
            height: 20.0,
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
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
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
                    onChanged: (pin) {
                      setState(() {
                        _pin = pin;
                      });
                    },
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
            height: 10.0,
            color: Colors.transparent,
          ),

          // what's this
          Container(
            margin:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
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
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    color: Constants.mainPrimary,
                    disabledElevation: 0,
                    disabledColor: Color.alphaBlend(
                        Colors.white54, Theme.of(context).primaryColor),
                    onPressed: (_email == "" || _pin == "" || _loading)
                        ? null
                        : () async {
                            try {
                              await _activate();
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

          // Demo button goes here
          // Container(
          //   margin:
          //       const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 50.0),
          //   child: Row(
          //     children: <Widget>[
          //       Spacer(),
          //       FlatButton(
          //         textColor: Constants.mainPrimary,
          //         splashColor: Constants.mainPrimaryLight,
          //         child: Text(
          //           "Skip this step, Try out a demo",
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             fontWeight: FontWeight.w400,
          //             fontSize: 15.0,
          //           ),
          //         ),
          //         onPressed: () {
          //           widget.gotoSignup();
          //         },
          //       ),
          //       Spacer(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  _activate() async {
    setState(() {
      _loading = true;
    });

    Map<String, String> data = {'email': _email, 'pin': _pin};

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await post(ApiRequest.BASE_URL + '/activate',
        headers: headers, body: json.encode(data));

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 201:
        
        Map<String, dynamic> data = json.decode(response.body);
        
        // just in case the user closes the app after this page, we still wanna record this so we don't show them this screen anymore.
        SubscriptionItem sub = SubscriptionItem.fromJson(data['data']);
        // store it in database
        sub.insertToDb();
        // store token
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'token', value: data['token']);
        
        widget.onActivate(sub.user);
        break;

      case 422:
        Map<String, dynamic> data = json.decode(response.body);
        String msg = data['message'];
        Map errors = data['errors'];
        if (errors.values.toList().length > 0) {
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
