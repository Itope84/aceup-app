
import 'package:aceup/pages/json-classes/slide.dart';
import 'package:aceup/util/custom_html.dart';
import 'package:aceup/widgets/hint-button.dart';
// import 'package:aceup/widgets/main-header.dart';
import 'package:aceup/widgets/pagination.dart';
import 'package:aceup/widgets/return-button.dart';
import 'package:flutter/material.dart';

class DefaultSlide extends StatelessWidget {
  final String title;
  final Slide slide;
  final int index, total;
  final Function(int) jumpTo;

  DefaultSlide({this.title, this.slide, this.index, this.total, this.jumpTo});

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
                  data: slide.body,
                  useRichText: false,
                ),
                SizedBox(
                  height: 30.0,
                ),

                // Pagination
                Pagination(
                  total: total,
                  currentPage: index + 1,
                  navigationHandler: (int page) {
                    jumpTo(page);
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
                title,
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
          HintButton()
        ],
      ),
    );
  }
}

