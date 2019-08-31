import 'package:flutter/material.dart';
import '../util/const.dart';

class SelectAvatarScreen extends StatefulWidget {
  final Function onSelect;
  SelectAvatarScreen({this.onSelect});
  @override
  _SelectAvatarScreenState createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends State<SelectAvatarScreen> {
  List<Map> avatars = [];

  Widget defaultAvatar() {
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
          "TI",
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

  Widget avatarArray() {
    List<String> files = List.generate(9, (index) => 'assets/avatars/00' + (index + 1).toString() +'.png');

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

    return Column(
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) => avatars[(row * 3) + col]),
        );
      }),
    );
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
            child: Center(
                child: FlatButton(
              onPressed: () {
                widget.onSelect();
              },
              child: defaultAvatar(),
            )),
          ),
          avatarArray(),
        ],
      ),
    );
  }
}
