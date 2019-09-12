import 'package:aceup/pages/json-classes/option.dart';
import 'package:aceup/util/custom_html.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final dynamic question;
  final Function onAnswer;
  final Option attempt;
  final bool disableOptions;
  QuestionWidget({this.question, this.onAnswer, this.disableOptions, this.attempt});
  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int _selected;

  @override
  Widget build(BuildContext context) {
    List<Widget> _options = new List<Widget>();
    for (var i = 0; i < widget.question.options.length; i++) {
      _options.add(singleOption(i));
    }

    return Container(
      child: Column(
        children: <Widget>[
          CustomHtml(
            data: widget.question.body,
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
    Option _option = widget.question.options[index];
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(30, 30, 30, 0.3), blurRadius: 0.3)
            ],
            color: widget.disableOptions ? (_option.isAnswer 
                ? Theme.of(context).primaryColor
                : _selected == index || (widget.attempt != null && widget.attempt.key == _option.key) ? Colors.red : Colors.white70) : _selected == index ? Colors.orange[300] : Colors.white70),
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Row(
              children: <Widget>[
                Text(
                  String.fromCharCode(index + 65),
                  style: (widget.disableOptions && _option.isAnswer) ||
                          _selected == index || (widget.attempt != null && widget.attempt.key == _option.key)
                      ? TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)
                      : TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: CustomHtml(
                      data: _option.body,
                      useRichText: false,
                      textStyle: (widget.disableOptions && _option.isAnswer) ||
                          _selected == index || (widget.attempt != null && widget.attempt.key == _option.key)
                          ? TextStyle(color: Colors.white)
                          : TextStyle(),
                      ),
                ),
              ],
            )),
      ),
      onTap: () {
        if (widget.disableOptions) {
          return;
        }
        setState(() {
          _selected = index;
        });
        if (widget.onAnswer != null) {
          print(_option.key);
          widget.onAnswer(_option.key);
        }
      },
    );
  }

  void selectOption(Map option) {}
}
