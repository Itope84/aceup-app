import 'package:flutter/material.dart';
import 'main_screen.dart';
// import '../widgets/icon_badge.dart';
import '../pages/auth.dart';
import '../pages/select-avatar.dart';

class Entry extends StatefulWidget {
  static int initialPage() {
    Map pagesIndex = {
      'auth': 0,
      'selectAvatar': 1,
      'main': 2
    };

    // check if user is logged in
    if(3 - 1 == 1) {
      // check if user has selected avatar, if so
      // return pagesIndex['main'];
      // else
      // return pagesIndex['selectAvatar'];
      
    }
    // check if user is
    return pagesIndex['auth'];
  }

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  void initState() {
    super.initState();
  }

  PageController _pageController = PageController(initialPage: Entry.initialPage());
  // int _page = 0;

  void onLogIn() {
    setState(() {
      _pageController.jumpToPage(1);
    });
  }

  void goToMain() {
    setState(() {
      _pageController.jumpToPage(2);
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
        children: [AuthScreen(loginHandler: onLogIn), SelectAvatarScreen(onSelect: goToMain,), MainScreen()],
      ),
    );
  }
}
