import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  final Function navigationHandler;

  Pagination({this.navigationHandler});

  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: totalPageCountButtons(4),
      ),
    );
  }

  List<Widget> totalPageCountButtons(int pageCount) {
    List<Widget> buttons = [
      FloatingActionButton(
        heroTag: 'prevBtn',
        child: Icon(
          Icons.keyboard_backspace,
          color: Colors.red,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {},
      )
    ];

    for (var i = 1; i <= pageCount; i++) {
      buttons.add(
        FloatingActionButton(
          heroTag: 'pageBtn' + i.toString(),
          mini: true,
          child: Text(
            i.toString(),
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          backgroundColor: Colors.transparent,
          focusColor: Colors.blueGrey,
          elevation: 0,
          onPressed: widget.navigationHandler
        ),
      );
    }

    buttons.add(FloatingActionButton(
      heroTag: 'nextBtn',
      mini: true,
      child: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
    ));
    return buttons;
  }
}
