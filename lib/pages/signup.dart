import 'package:flutter/material.dart';
import '../util/const.dart';

class SignupScreen extends StatefulWidget {
  final String email;
  final Function signupHandler;
  final Function gotoLogin;

  SignupScreen({this.email, this.signupHandler, this.gotoLogin});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Widget label(String text) {
    return Constants.defaultInputLabel(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Constants.mainWhite,
      ),
      child: new ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                child: Text(
                  "Great work! Just a few more details",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          Container(
            padding: EdgeInsets.only(left: 40.0, bottom: 40.0),
            child: Text(
              "Your sign-in details",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                color: Constants.mainPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Email
          Constants.defaultInputWidget(
              label: "Email",
              disabled: widget.email != null && widget.email.length != 0,
              type: TextInputType.emailAddress,
              placeholder: 'email@gmail.com',
              controller: TextEditingController(text: widget.email)),
          SizedBox(
            height: 20.0,
          ),

          //  username
          Constants.defaultInputWidget(
              label: "Username",
              type: TextInputType.text,
              placeholder: 'Awesomedude091',
              controller: TextEditingController(text: "")),

          SizedBox(height: 20.0),

          // password
          Constants.defaultInputWidget(
              label: "Password",
              type: TextInputType.text,
              placeholder: '******',
              obscureText: true,
              controller: TextEditingController(text: "")),

          SizedBox(
            height: 10.0,
          ),

          // Optional Text
          new Container(
            margin: EdgeInsets.only(bottom: 30.0, top: 15.0),
            child: new Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: new Text(
                "Optional",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(244, 16, 16, 1),
                  fontSize: 15.0,
                ),
              ),
            ),
          ),

          // Firstname
          label("First Name"),
          Container(
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
                    // controller: TextEditingController(text: email),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'John',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),

          label("Last Name"),
          Container(
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
                    // controller: TextEditingController(text: email),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Doe',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),

          // Phone number
          Constants.defaultInputWidget(
              label: "Phone Number",
              type: TextInputType.phone,
              placeholder: '08181634383',
              controller: TextEditingController(text: "")),

          SizedBox(
            height: 20.0,
          ),

          // Signup button
          Container(
            margin: const EdgeInsets.only(
                left: 30.0, right: 30.0, bottom: 20.0, top: 20.0),
            alignment: Alignment.center,
            child: new RaisedButton(
              elevation: 1.0,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              color: Constants.mainPrimary,
              onPressed: () {
                widget.signupHandler();
              },
              child: new Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Container(
            margin:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 50.0),
            child: Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  textColor: Constants.mainPrimary,
                  splashColor: Constants.mainPrimaryLight,
                  child: Text(
                    "Already registered? Sign in instead",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    widget.gotoLogin();
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
