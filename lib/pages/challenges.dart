import 'package:aceup/util/const.dart';
import 'package:aceup/widgets/screen-title.dart';
import 'package:flutter/material.dart';

class ChallengesScreen extends StatefulWidget {
  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ScreenTitle("Challenges"),
          Container(
            padding: EdgeInsets.all(30.0),
            child: RaisedButton(
              child: Text("Challenge Someone"),
              onPressed: () {},
              color: Theme.of(context).primaryColor,
              textColor: Constants.mainWhite,
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Recent Challenges",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).accentColor),
                ),
              ],
            ),
          ),
          challengesList()
        ],
      ),
    );
  }

  Widget challengesList() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: singlePastChallenge(index),
          );
        },
      ),
    );
  }

  Widget singlePastChallenge(index) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(30, 30, 30, 0.3), blurRadius: 0.3)
            ],
            color: Colors.white70),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/avatars/001.png',
                    width: 25.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Flexible(
                    child: Text(
                      "SantiagoAmos",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "1",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "-",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "2",
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 5.0,
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/avatars/001.png',
                    width: 25.0,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Santiago",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }
}
