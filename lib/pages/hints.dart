import 'package:aceup/widgets/block-button.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class Hint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hints and Tips"),
      ),
      // backgroundColor: Th,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(
                "Selecting Options",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      "While solving questions in which options have equations, please click outside the white box!")
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Equation Loading",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      "Pages with equations might take some time to load. However everything has been optimised so you do not have to be connected to the internet while learning")
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Adding a new Course",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                children: <Widget>[
                  RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                          fontSize: 14.0, color: Colors.black, height: 1.2),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                "Wanna add a new course to your profile? Click on the profile icon at the top of any page, then scroll to the bottom of the (profile) page and click "),
                        new TextSpan(
                            text: '\"Add Subscription\"',
                            style: new TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Leaderboard",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      "Level Up on the leaderboard by completing quizzes and challenges! The more questions you solve, the higher you go. NB: Leaderboards are different for each course")
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Switching Active Course",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      "If you subscribe for more than one course, you might want to switch the active course. Simply click on the menu icon and from the resulting drawer, select your course. You can also open the drawer by swiping from the left (kinda like pulling it in) from the left on the homepage")
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Contact Support",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Wrap(
                children: <Widget>[
                  Text(
                      "Encountering any issues with the app? Kindly click the button below to let us know")
                ],
              ),
              SizedBox(
                height: 15.0,
              ),

              // Get Pin, opens whatsapp
              Container(
                margin: const EdgeInsets.only(
                    left: 30.0, right: 30.0, bottom: 50.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: BlockButton(
                        child: Text(
                          "Contact Us",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                        onPressed: () async {
                          String url = "whatsapp://send?phone=2349034971989";
                          if (await canLaunch(url)) {
                            launch(url);
                          } else {
                            Toast.show("Whatsapp is not installed", context);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
