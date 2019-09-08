import 'package:aceup/pages/json-classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main_screen.dart';
// import '../widgets/icon_badge.dart';
import '../pages/auth.dart';
import '../pages/select-avatar.dart';

class Entry extends StatefulWidget {
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  void initState() {
    super.initState();
  }

  final storage = new FlutterSecureStorage();

  Future<PageController> getInitialPage() async {
    String token = await storage.read(key: 'token');
    List<User> users = await User.users();
    PageController _pageController;
    Map pagesIndex = {'auth': 0, 'selectAvatar': 1, 'main': 2};

    if (token != null && users.length > 0 && users.last.username != null) {
      User user = users.last;
      if (user.avatarId != null) {
        _pageController = PageController(initialPage: pagesIndex['main']);
      } else {
        _pageController =
            PageController(initialPage: pagesIndex['selectAvatar']);
      }
    } else {
      _pageController = PageController(initialPage: pagesIndex['auth']);
    }
    return _pageController;
  }

  // int _page = 0;

  Function goToPage(int page, PageController controller) {
    return () {
      setState(() {
        controller.jumpToPage(page);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: getInitialPage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          PageController _pageController = snapshot.data;
          return PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            // onPageChanged: onPageChanged,
            // bogus, simply generates 4 pages, all of them is home shikena
            children: [
              AuthScreen(loginHandler: goToPage(1, _pageController)),
              SelectAvatarScreen(
                onSelect: goToPage(2, _pageController),
              ),
              MainScreen()
            ],
          );
        } else {
          return Container();
        }
      },
    ));
  }
}
