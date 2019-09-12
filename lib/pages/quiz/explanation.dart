import 'package:aceup/pages/json-classes/question.dart';
import 'package:aceup/util/custom_html.dart';
import 'package:flutter/material.dart';

class Explanation extends StatelessWidget {
  final Question question;
  Explanation({this.question});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explanation"),
      ),
      // backgroundColor: Th,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: CustomHtml(
            data: question.explanation != null ? question.explanation : "No explanation available for this question",
          ),
        ),
      ),
    );
  }
}
