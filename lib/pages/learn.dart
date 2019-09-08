import 'package:aceup/pages/topic/introduction.dart';
import 'package:aceup/util/const.dart';
import 'package:aceup/widgets/screen-title.dart';
import 'package:flutter/material.dart';
// import 'details.dart';

class Learn extends StatefulWidget {
  // final changeThemeHandler;

  // Learn(this.changeThemeHandler);
  @override
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  // final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ScreenTitle("Learn"),

          // Course Banner
          Container(
            padding: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
            margin: EdgeInsets.only(bottom: 30.0),
            alignment: Alignment.center,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/chemistry.png")),
                        ),
                        height: 170,
                      ),
                    ),
                    SizedBox(height: 7),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "CHM101 - INTRODUCTORY CHEMISTRY I",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 3),
                  ],
                ),
              ),
          ),

          // Body of the page
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Learn",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              ),
            ),
          ),

          topicList(),
        ],
      ),
    );
  }

  Widget topicList() {
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
            child: InkWell(
              child: Container(
                height: 70,
//                    color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          "02",
                          style: TextStyle(
                              color: Constants.mainWhite,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      width: 50.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: index == 1
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: index == 1
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).accentColor,
                        ),
                        child: Text(
                          "Organic Reagents and Reactions and Factors affecting them",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.0, color: Constants.mainWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Introduction();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
