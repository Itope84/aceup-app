import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  final Function navigationHandler;

  final int total, currentPage;

  Pagination({this.navigationHandler, this.total, this.currentPage});

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
        onPressed: () {
          widget.navigationHandler(widget.currentPage - 1);
        },
      )
    ];

    int first = widget.currentPage < 3 ? 1 : widget.currentPage - 2;
    for (var i = first; i <= (first + 3 > widget.total ? widget.total : first + 3); i++) {
      buttons.add(
        FloatingActionButton(
          heroTag: 'pageBtn' + i.toString(),
          mini: true,
          child: Text(
            i.toString(),
            style: TextStyle(color: i == widget.currentPage ? Theme.of(context).primaryColor : Theme.of(context).accentColor),
          ),
          backgroundColor: Colors.transparent,
          focusColor: Colors.blueGrey,
          elevation: 0,
          onPressed: () {
            widget.navigationHandler(i - 1);
          }
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
      onPressed: () {
        widget.navigationHandler(widget.currentPage + 1);
      },
    ));
    return buttons;
  }
}
