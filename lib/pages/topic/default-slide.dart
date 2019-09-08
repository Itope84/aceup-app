import 'dart:convert';

import 'package:aceup/pages/topic/question-slide.dart';
import 'package:aceup/util/custom_html.dart';
// import 'package:aceup/widgets/main-header.dart';
import 'package:aceup/widgets/pagination.dart';
import 'package:aceup/widgets/return-button.dart';
import 'package:flutter/material.dart';

class DefaultSlide extends StatefulWidget {
  @override
  _DefaultSlideState createState() => _DefaultSlideState();
}

class _DefaultSlideState extends State<DefaultSlide> {
  static String str0 = r"""
  {
"id": 9,
"topic_id": 1,
"index": 4,
"body": "<h3>Quadrant formula</h3>\n\n<p>In this section, we will be making use of the fact that trigonometric functions are periodic functions.(By periodic, we mean the values reappear at intervals, for example, sin 30&deg; is the same as sin 150&deg;).</p>\n\n<p>The set of angles 0 - 360&deg; can be divided into the following quadrants.</p>\n\n<p><img alt=\"\" src=\"http://res.cloudinary.com/dzbxciyvo/image/upload/c_fit,h_218,w_273/rh69mmhlexfr3xaphcnw.png\" /></p>\n\n<p>From the diagram above, the angle in red (e.g <code style=\"color:red;\">180-<!--(figmeta)eyJmaWxlS2V5IjoiVDFDYXZoTUFscm9KeENJTWVId0xiNyIsInBhc3RlSUQiOi0xLCJkYXRhVHlwZSI6InNjZW5lIn0K(/figmeta)--><!--(figma)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(/figma)-->&theta;</code>&nbsp;in the second quadrant) is the acute equivalent of the actual angle, while the statement below it indicates the sign. i.e we replace the actual angle in the question&nbsp;with the angle in red.</p>\n\n<p>So, for example:<br />\nsin(230&deg;)&nbsp;is in the third quadrant, which means the acute equivalent is&nbsp;<code style=\"color:red;\">230&deg;-180</code>&nbsp;and the sign is -ve (because only Tan is +ve in 3rd quadrant).<br />\nHence, we replace (230) with (<code style=\"color:red\">230-180</code>). i.e sin(230&deg;) = -sin(<code style=\"color:red\">230-180</code>)&deg;.</p>\n\n<p>Other expressions that can be deduced from the diagram include:</p>\n\n<ol>\n\t<li><span class=\"math-tex\">\\(sin\\theta = cos(90-\\theta)\\)</span>&nbsp;and vice versa</li>\n\t<li><span class=\"math-tex\">\\(cos(180-\\theta)=-cos\\theta\\)</span></li>\n\t<li><span class=\"math-tex\">\\(tan(180-\\theta)=-tan\\theta\\)</span></li>\n\t<li><span class=\"math-tex\">\\(sin(180-\\theta)=sin\\theta\\)</span></li>\n</ol>\n\n<p><strong>DIY: </strong>The pattern in items 2, 3 and 4 above are from the second quadrant. Why not try deducing other expressions from the third and fourth quadrants.</p>\n\n<p>Just before we leave, were you wondering if angles could exceed beyond 360&deg;? Well, news flash: they can! 😀<br />\nWait a minute, so that means a question can ask you to evaluate <span class=\"math-tex\">\\(sin(1020)\\)</span>. But that table doesn&#39;t go beyond 360 na&nbsp;😩</p>\n\n<p>Well, don&#39;t panic!&nbsp;Remember that trig functions are periodic. This also means that they repeat their values every 360&deg;. This means 420&deg; can also be treated as (420 - 360)&deg; = 60&deg;.<br />\nSo, sin(500&deg;) = sin(500 - 360)&deg; = sin140&deg;</p>\n\n<p>Angles beyond 360 = 360n + basic angle</p>\n\n<p>Cool&nbsp;😎, right?</p>\n\n<p>So, let&#39;s take a look at one last example together:</p>\n\n<p>Evaluate <span class=\"math-tex\">\\(cos(750^\\circ)\\)</span><br />\n<strong>solution:</strong><br />\n<span class=\"math-tex\">\\(750 = 360+360+30\\)</span>,<br />\nhence&nbsp;<span class=\"math-tex\">\\(cos(750) = cos(30)\\)</span>&nbsp;(i.e. we can discard all the preceeding 360s!)</p>\n\n<p>I can see you bringing out your calculator to evaluate cos(30)&nbsp;😏. That might be a bit expensive in some situations. In the next slide, we&#39;ll talk about a small trick you could use to evaluate special trigonometric ratios like 30&deg;, 45&deg;, 60&deg; and 90&deg;</p>",
"is_question": 0,
"options": null,
"explanation": null,
"created_at": "2019-09-04 17:59:08",
"updated_at": "2019-09-04 19:10:52"
}
  """;
  static String text = str0.replaceAllMapped(
      RegExp(r'<span class=\\\"math-tex\\\"[^>]*>((.|\\n)*?)<\/span>'),
      (match) {
    return '${match.group(1)}';
  });

  String str = jsonDecode(text)["body"];
  
  // String str = text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 100),
                CustomHtml(
                  data: str,
                  useRichText: false,
                ),
                SizedBox(
                  height: 30.0,
                ),

                // Pagination
                Pagination(
                  navigationHandler: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => QuestionSlide()));
                  },
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
              color: Theme.of(context).backgroundColor,
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
          ReturnButton(onPressed: () {
            Navigator.pop(context);
          }),
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
