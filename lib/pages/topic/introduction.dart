import 'package:aceup/util/custom_html.dart';
import 'package:aceup/widgets/block-button.dart';
import 'package:aceup/widgets/main-header.dart';
import 'package:aceup/widgets/return-button.dart';
import 'package:flutter/material.dart';
import './default-slide.dart';

class Introduction extends StatefulWidget {
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  // String str = """
  // <p><strong>QUALITATIVE ANALYSIS</strong></p>\n\n<p>After isolation and purification through column chromatography for example, we then need to carry out some chemical tests on the purified compound to identify what elements the compound is made of. Qualitatively analyzing an organic compound simply mean carrying out tests to know the elemental composition of the isolated compound.</p>\n\n<p>Therefore, there is need to carry out each test on the organic compound to detect the elements present.</p>\n\n<p>&nbsp;</p>\n\n<p><strong>QUANTITATIVE ANALYSIS</strong></p>\n\n<p>In qualitative analysis, the goal is to identify each elemental composition of the unknown organic compound. Quantitative analysis is a build-up on qualitative analysis because here, we are not just interested in what element is present but how much (mg, g, mole, % etc.) of each element is present. Since previous qualitative test would have revealed to us the elements present in the unknown compound, we then carry out quantitative estimation of those elements confirmed to be present. To accomplish this, quantitative analysis has its own techniques and usually involve simple calculations to quantify each element present in a known mass of an organic compound.</p>
  // """;
  String str = """
  <p>This is one of the methods of preparation of alkanal:<br />\n<img alt=\"\" src=\"http://res.cloudinary.com/dzbxciyvo/image/upload/c_fit,h_132,w_636/rumaxagluexlgpxxhmpk.png\" /><br />\nNOTE: That Ca &nbsp;is used to represent&nbsp;&nbsp;<span class=\"math-tex\">\\(½Ca^{2+}\\)</span> (i.e. Ca+), &nbsp; &nbsp;hence&nbsp;<span class=\"math-tex\">\\( 2Ca \\)</span>= <span class=\"math-tex\">\\(Ca^{2+}\\)</span>. This is used so as to aid comprehension as well as to reduce ambiguity and it will NOT affect the result.<br />\nThe product given in the question is hexanal &nbsp;i.e.<br />\n<img alt=\"\" src=\"http://res.cloudinary.com/dzbxciyvo/image/upload/c_fit,h_109,w_620/wjrvqhgbnvxlclweppra.png\" /><br />\nFollowing the general equation:<br />\n<img alt=\"\" src=\"http://res.cloudinary.com/dzbxciyvo/image/upload/c_fit,h_124,w_620/nxczu27kab7dmkqtwoly.png\" /><br />\n<br />\nTherefore, the calcium alkanoates used are: <span class=\"math-tex\">\\( (C_5H_{11}COO)_2Ca \\\\ Calcium \\ hexanoate \\)</span>&nbsp; and&nbsp;<span class=\"math-tex\">\\( (HCOO)_2Ca  \\\\ Calcium methanoate\\)</span><br />\n&nbsp;</p>
  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                // Container(
                //   child: Text(
                //     "Introduction",
                //     style: TextStyle(
                //         color: Theme.of(context).accentColor, fontSize: 20.0),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                SizedBox(height: 80),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          "02",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(child: MainHeader("Limits")),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                MainHeader("Introduction."),
                CustomHtml(
                  data: str,
                  useRichText: false,
                ),
                SizedBox(
                  height: 30.0,
                ),
                BlockButton(
                  onPressed: (){
                    Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DefaultSlide();
                    },
                  ),
                );
                  },
                  child: Text("Start Learning"),
                ),
                BlockButton(
                  color: Theme.of(context).accentColor,
                  onPressed: (){},
                  child: Text("Solve Questions"),
                ),
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
                "Introduction",
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
