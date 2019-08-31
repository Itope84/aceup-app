import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'learn.dart';
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
  final List<Widget> topLevelPages = [Home(), Learn(), Home(), Home(), Home()];

  @override
  Widget build(BuildContext context) {
    Widget bottomBarIcon(
        {IconData icon = Icons.home, int page = 0, bool badge = false}) {
      return IconButton(
        icon: badge ? IconBadge(icon: icon, size: 24) : Icon(icon, size: 24),
        color: _page == page
            ? Theme.of(context).primaryColor
            : Theme.of(context).accentColor,
        onPressed: () => _pageController.jumpToPage(page),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle,
            ),
            onPressed: () {
              // widget.changeThemeHandler();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.lightbulb_outline,
            ),
            onPressed: () {
              // widget.changeThemeHandler();
            },
          ),
        ],
      ),
      body: PageView(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        // bogus, simply generates 4 pages, all of them is home shikena
        children: List.generate(5, (index) => topLevelPages[index]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 7),
            bottomBarIcon(icon: Icons.home, page: 0),
            bottomBarIcon(icon: MdiIcons.bookOpenPageVariant, page: 1),
            bottomBarIcon(icon: MdiIcons.gamepadVariant, page: 2),
            bottomBarIcon(icon: MdiIcons.medal, page: 3),
            bottomBarIcon(icon: MdiIcons.podium, page: 4),
            SizedBox(width: 7),
          ],
        ),
        color: Theme.of(context).backgroundColor,
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
