import 'package:aceup/util/const.dart';
import 'package:flutter/material.dart';

class Avatars {
  static List<String> files = List.generate(
      9, (index) => 'assets/avatars/00' + (index + 1).toString() + '.png');

  static get avatars {
    List<Widget> avatars = [];

    files.forEach((file) {
      avatars.add(Container(
        margin: EdgeInsets.all(13),
        child: Image.asset(
          file,
          width: 80.0,
        ),
      ));
    });

    return avatars;
  }

  static smallAvatars(double width, {double margin}) {
    List<Widget> avatars = [];

    files.forEach((file) {
      avatars.add(Container(
        margin: EdgeInsets.all(margin != null ? margin :  13),
        child: Image.asset(
          file,
          width: width,
        ),
      ));
    });

    return avatars;
  }
  
  static Widget avatarFromId(int avatarId, {String username, double width, double margin}) {
    return avatarId != null && avatarId > 0 ? width != null ? smallAvatars(width, margin: margin)[avatarId - 1] : avatars[avatarId - 1] : defaultAvatar(username: username != null ? username.toUpperCase() : null, width: width, margin: margin);
  }

  static Widget defaultAvatar({String username, double width, double margin}) {
    Widget nameAvatar = Container(
      margin: EdgeInsets.all(margin != null ? margin : 13),
      width: width != null ? width : 80.0,
      height: width != null ? width : 80.0,
      decoration: new BoxDecoration(
        color: Constants.mainPrimaryLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          username != null ? username.substring(0, 1) + username.substring(username.length - 2, username.length - 1) : "?",
          style: TextStyle(
            fontSize: width != null ? width / 2 : 40,
            color: Constants.mainWhite,
            fontWeight: width != null ? FontWeight.bold : FontWeight.w900,
          ),
        ),
      ),
    );

    return nameAvatar;
  }
}
