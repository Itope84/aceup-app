import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 70.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/avatars/001.png',
                        width: 80.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Kehinde Ademola",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).backgroundColor),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Itope84",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).backgroundColor),
                      ),
                    ],
                  ),
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Rank",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "240",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    Container(
                      height: 50.0,
                      width: 1.0,
                      color: Theme.of(context).accentColor,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Points",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "60",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20, left: 30),
                  child: Text(
                    "Registered Courses",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor),
                  ),
                ),

                // Course Banner
                Container(
                  padding: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                  margin: EdgeInsets.only(bottom: 30.0),
                  alignment: Alignment.center,
                  child: InkWell(
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
                    onTap: () {},
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                  margin: EdgeInsets.only(bottom: 30.0),
                  alignment: Alignment.center,
                  child: InkWell(
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
                                    image: AssetImage("assets/mth-105.png")),
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
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 0.0,
            width: 60.0,
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              elevation: 0.0,
              color: Theme.of(context).primaryColor,
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 50,
            width: 60.0,
            right: 0.0,
            child: RaisedButton(
              elevation: 0.0,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              color: Theme.of(context).primaryColor,
              child: Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0))),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
