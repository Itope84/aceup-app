import 'package:flutter/material.dart';
import 'home.dart';
import '../widgets/icon_badge.dart';

class MainScreen extends StatefulWidget {
  // final changeThemeHandler;

  // MainScreen(this.changeThemeHandler);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    Widget bottomBarIcon(
        {IconData icon = Icons.home, int page = 0, bool badge = false}) {
      return IconButton(
        icon: badge ? IconBadge(icon: icon, size: 24) : Icon(icon, size: 24),
        color: _page == page
            ? Theme.of(context).accentColor
            : Colors.blueGrey[300],
        onPressed: () => _pageController.jumpToPage(page),
      );
    }

    return Scaffold(
      body: PageView(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        // bogus, simply generates 4 pages, all of them is home shikena
        children: List.generate(5, (index) => Home()),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            bottomBarIcon(icon: Icons.home, page: 0),
            bottomBarIcon(icon: Icons.favorite, page: 1),
            bottomBarIcon(icon: Icons.mode_comment, page: 2, badge: true),
            bottomBarIcon(icon: Icons.person, page: 3),
            bottomBarIcon(icon: Icons.verified_user, page: 4),
            SizedBox(width: 7),
          ],
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
