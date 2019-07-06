import 'package:flutter/material.dart';
import 'main_screen.dart';
// import '../widgets/icon_badge.dart';
import '../pages/auth.dart';

class Entry extends StatefulWidget {
  static bool isLoggedIn() {
    if(3 - 1 == 1) {
      return true;
    }
    return false;
  }

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  void initState() {
    super.initState();
  }

  PageController _pageController = PageController(initialPage: Entry.isLoggedIn() ? 1 : 0);
  // int _page = 0;

  void onLogIn() {
    setState(() {
      _pageController.jumpToPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        // onPageChanged: onPageChanged,
        // bogus, simply generates 4 pages, all of them is home shikena
        children: [AuthScreen(loginHandler: onLogIn), MainScreen()],
      ),
    );
  }
}
