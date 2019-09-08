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
  
  static Widget avatarFromId(int avatarId, {String firstname, String lastname}) {
    return avatarId > 0 ? avatars[avatarId - 1] : defaultAvatar(firstname: firstname, lastname: lastname);
  }

  static Widget defaultAvatar({String firstname, String lastname}) {
    Widget nameAvatar = Container(
      margin: EdgeInsets.all(13),
      width: 80.0,
      height: 80.0,
      decoration: new BoxDecoration(
        color: Constants.mainPrimaryLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          firstname != null && lastname != null ? firstname.substring(0, 1) + lastname.substring(0, 1) : "?",
          style: TextStyle(
            fontSize: 40,
            color: Constants.mainWhite,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );

    return nameAvatar;
  }
}
