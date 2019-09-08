import 'package:aceup/util/custom_html.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Map question;
  QuestionWidget({this.question});
  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int _selected;

  @override
  Widget build(BuildContext context) {
    List<Widget> _options = new List<Widget>();
    for (var i = 0; i < widget.question['options'].length; i++) {
      _options.add(singleOption(i));
    }

    return Container(
      child: Column(
        children: <Widget>[
          CustomHtml(
            data: widget.question['body'],
            useRichText: false,
          ),
          SizedBox(
            height: 30.0,
          ),
          Column(
            children: _options,
          )
        ],
      ),
    );
  }

  Widget singleOption(index) {
    Map _option = widget.question['options'][index];
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(30, 30, 30, 0.3), blurRadius: 0.3)
            ],
            color: _selected != null && _option['is_answer'] ? Theme.of(context).primaryColor : _selected == index ? Colors.red : Colors.white70),
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Row(
              children: <Widget>[
                Text(
                  String.fromCharCode(index + 65),
                  
                  style: (_selected != null && _option['is_answer']) || _selected == index ? TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white) : TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: CustomHtml(data: _option['body']),
                )
              ],
            )),
      ),
      onTap: () {
        if(_selected != null) {
          return;
        }
        setState(() {
          _selected = index;
        });
      },
    );
  }

  void selectOption(Map option) {}
}
