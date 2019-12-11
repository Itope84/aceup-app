import 'dart:convert';

import 'package:aceup/pages/json-classes/subscription-item.dart';
import 'package:aceup/util/requests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import '../util/const.dart';

class AddSubscription extends StatefulWidget {
  final Function onActivate;
  AddSubscription({this.onActivate});
  @override
  _AddSubscriptionState createState() => _AddSubscriptionState();
}

class _AddSubscriptionState extends State<AddSubscription> {
  String _pin = "";
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AceUp - Add Subscription"),
      ),
      body: Container(
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
                    "ADD SUBSCRIPTION",
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
                "Enter pin to create new subscription",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            SizedBox(height: 50.0,),

            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "Enter Pin",
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

            SizedBox(height: 20.0,),

            Row(
              // silly, I know
              children: <Widget>[
                SizedBox(width: 20.0,),
                Expanded(
                  child: Text(
                    "The pin needs to be registered to the same email account you signed up with",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 20.0,),
              ],
            ),

            SizedBox(height: 20.0,),

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
                      onPressed: (_pin == "" || _loading)
                          ? null
                          : () async {
                              try {
                                await _activate();
                              } catch (_) {
                                Toast.show("Unable to activate pin!", context,
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
                                      "Let's go",
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
          ],
        ),
      ),
    );
  }

  _activate() async {
    setState(() {
      _loading = true;
    });

    Map<String, String> data = {'pin': _pin};

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await post(ApiRequest.BASE_URL + '/subscriptions/new',
        headers: headers, body: json.encode(data));

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 201:
        Map<String, dynamic> data = json.decode(response.body);

        SubscriptionItem sub = SubscriptionItem.fromJson(data['data']);
        // store it in database
        sub.insertToDb();

        widget.onActivate();
        Navigator.of(context).pop();
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
