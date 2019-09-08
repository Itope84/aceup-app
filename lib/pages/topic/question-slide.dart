import 'dart:convert';

import 'package:aceup/models/theme_model.dart';
import 'package:aceup/util/const.dart';
import 'package:aceup/widgets/pagination.dart';
import 'package:aceup/widgets/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class QuestionSlide extends StatefulWidget {
  @override
  _QuestionSlideState createState() => _QuestionSlideState();
}

class _QuestionSlideState extends State<QuestionSlide> {
  static String str = r"""
  {
"id": 10,
"topic_id": 3,
"body": "<p>In which of the following do we have ionic bond:</p>\n\n<p>I.&nbsp;<span class=\"math-tex\">\\( SbI_3 \\)</span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;II. <span class=\"math-tex\">\\(SbF_3 \\)</span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;III.&nbsp;<span class=\"math-tex\">\\( SbCl_3\\)</span> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;IV. <span class=\"math-tex\">\\(PCl_3 \\)</span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;V.&nbsp;<span class=\"math-tex\">\\( NBr_3\\)</span></p>",
"options": [
{
"key": "A",
"body": "<p>I only &nbsp;</p>",
"is_answer": false
},
{
"key": "B",
"body": "<p>II and III</p>",
"is_answer": false
},
{
"key": "C",
"body": "<p>III, IV and V</p>",
"is_answer": false
},
{
"key": "D",
"body": "<p>II only &nbsp;</p>",
"is_answer": true
}
],
"difficulty": "medium",
"explanation": "<p>Only <span class=\"math-tex\">\\(SbF_3\\)</span> has has Ionic bond</p>",
"created_at": "2019-08-30 13:57:40",
"updated_at": "2019-08-30 13:57:40",
"topic": {
"id": 3,
"course_id": 2,
"index": 2,
"title": "Chemical Bonding and Shapes of Molecules",
"introduction": "<p>the topic of this chapter&mdash;which explains how individual atoms connect to form more complex structures.</p>",
"created_at": "2019-08-29 12:36:01",
"updated_at": "2019-08-29 12:36:01"
}
}
  """;

  static String eqnparsed = str.replaceAllMapped(
      RegExp(r'<span class=\\\"math-tex\\\"[^>]*>((.|\\n)*?)<\/span>'),
      (match) {
    return '${match.group(1)}';
  });

  Map _question = jsonDecode(eqnparsed);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ThemeModel>(
      builder: (context, widget, model) {

        return WillPopScope(
          onWillPop: () async => false,
            child: Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 100),

                      Text(
                      "Question",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),

                      // body
                      QuestionWidget(
                        question: _question,
                      ),

                      SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                ),

                // My own custom AppBar
                Positioned(
                  top: 0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 70.0, right: 70.0, top: 60.0, bottom: 10.0),
                    child: Text(
                      "Limits",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  width: 60.0,
                  right: 0.0,
                  child: RaisedButton(
                    elevation: 0.0,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
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
          ),
        );
      },
    );
  }
}
