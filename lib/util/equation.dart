import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class EquationBlock extends StatefulWidget {
  final String texHtml;
  EquationBlock({this.texHtml});
  @override
  _EquationBlockState createState() => _EquationBlockState();
}

class _EquationBlockState extends State<EquationBlock> {
  int _stackToView = 0;
  // void _handleLoad(String value) {
  //   setState(() {
  //     _stackToView = 0;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // return IndexedStack(
    //   index: _stackToView,
    //   children: <Widget>[

    //     Container(
    //       padding: EdgeInsets.all(10.0),
    //       width: MediaQuery.of(context).size.width,
    //       alignment: Alignment.center,
    //       child: SizedBox(
    //         height: 30.0,
    //         width: 30.0,
    //         child: CircularProgressIndicator(),
    //       ),
    //     ),
    //     TeXView(
    //       teXHTML: widget.texHtml,
    //       onPageFinished: (val) {
    //         print(val);
    //         setState(() {
    //           _stackToView = 1;
    //         });
    //       },
    //     ),
    //   ],
    // );
    return TeXView(
      teXHTML: widget.texHtml
    );
  }
}
