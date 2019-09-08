import 'dart:convert';
import 'package:toast/toast.dart';

import './json-classes/user.dart';
import 'package:aceup/util/avatar.dart';
import 'package:aceup/util/requests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../util/const.dart';

class SelectAvatarScreen extends StatefulWidget {
  final Function onSelect;
  SelectAvatarScreen({this.onSelect});
  @override
  _SelectAvatarScreenState createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends State<SelectAvatarScreen> {
  List<Map> avatars = [];
  int _selected;

  selectAvatar(int index) async {
    setState(() {
      _selected = index;
    });

    Map<String, dynamic> data = {'avatar_id': index};

    Map<String, String> headers = await ApiRequest.headers();

    Response response = await post(
        ApiRequest.BASE_URL + '/users/profile/avatar',
        headers: headers,
        body: json.encode(data));

    int statusCode = response.statusCode;

    switch (statusCode) {
      case 200:
      case 201:
        Map<String, dynamic> data = json.decode(response.body);

        // just in case the user closes the app after this page, we still wanna record this so we don't show them this screen anymore.
        User user = User.fromJson(data['data']);
        // store it in database
        user.insertToDb();

        widget.onSelect();
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

  Widget avatarArray() {
    // List<Widget> avatars = Avatars.avatars;

    return Column(
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              3,
              (col) => avatarWidget(
                  child: Avatars.avatarFromId((row * 3) + col + 1),
                  index: (row * 3) + col + 1)),
        );
      }),
    );
  }

  Widget avatarWidget({@required Widget child, index: 0}) {
    return InkWell(
        onTap: _selected != null
            ? null
            : () async {
                await selectAvatar(index);
                setState(() {
                  _selected = null;
                });
              },
        child: _selected == index
            ? Container(
                margin: EdgeInsets.all(13),
                width: 80.0,
                height: 80.0,
                decoration: new BoxDecoration(
                  color: Constants.mainPrimaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(child: CircularProgressIndicator()),
              )
            : child);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
      decoration: BoxDecoration(
        color: Constants.mainWhite,
      ),
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Center(
              child: Text(
                "Select an Avatar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Constants.mainPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 40.0),
            child: avatarWidget(child: Avatars.avatarFromId(0), index: 0),
          ),
          avatarArray(),
        ],
      ),
    );
  }
}
