import 'package:flutter/material.dart';
import '../util/const.dart';

class DefaultTextInput extends StatefulWidget {
  final String label;
  final TextInputType type;
  final bool disabled;
  final String placeholder;
  final bool capitalize;
  final Function(String val) onChange;
  final Widget suffixIcon;
  final bool obscureText;
  final String initialValue;

  DefaultTextInput({
    this.label,
    this.type: TextInputType.text,
    this.disabled: false,
    this.placeholder,
    this.capitalize: false,
    this.onChange,
    this.suffixIcon,
    this.initialValue,
    this.obscureText: false,
  });
  
  @override
  _DefaultTextInputState createState() => _DefaultTextInputState();
}

class _DefaultTextInputState extends State<DefaultTextInput> {
  TextEditingController _textController;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue);
    _textController.addListener(_updateChanges);
  }

  _updateChanges() {
    widget.onChange(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: defaultInputWidget(),
    );
  }

  Widget defaultInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: new Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Constants.mainPrimary,
          fontSize: 15.0,
        ),
      ),
    );
  }

  Widget defaultInputWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        defaultInputLabel(widget.label),
        Container(
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: widget.disabled ? Color(0xffeeeeee) : Constants.mainPrimary,
                  width: 0.5,
                  style: BorderStyle.solid),
            ),
          ),
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: TextFormField(
            obscureText: widget.obscureText,
            keyboardType: widget.type,
            controller: _textController,
            textCapitalization: widget.capitalize
                ? TextCapitalization.sentences
                : TextCapitalization.none,
            enabled: !widget.disabled,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon,
              filled: widget.disabled ? true : false,
              fillColor: Color(0xffeeeeee),
              border: InputBorder.none,
              hintText: widget.placeholder,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
