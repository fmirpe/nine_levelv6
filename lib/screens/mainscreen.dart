import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:nine_levelv6/components/fab_container.dart';
import 'package:nine_levelv6/pages/coaching.dart';
import 'package:nine_levelv6/pages/driver.dart';
import 'package:nine_levelv6/pages/marketplace.dart';
import 'package:nine_levelv6/pages/notification.dart';
import 'package:nine_levelv6/pages/profile.dart';
import 'package:nine_levelv6/pages/search.dart';
import 'package:nine_levelv6/pages/feeds.dart';
import 'package:nine_levelv6/pages/travel.dart';
import 'package:nine_levelv6/utils/constants.dart';
import 'package:nine_levelv6/utils/firebase.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _page = 0;

  List pages = [
    {
      'title': 'Home',
      'icon': CupertinoIcons.home,
      'page': Timeline(),
      'index': 0,
    },
    {
      'title': 'Search',
      'icon': CupertinoIcons.search,
      'page': Search(),
      'index': 1,
    },
    {
      'title': 'unsee',
      'icon': Feather.plus_circle,
      'page': Text('nes'),
      'index': 2,
    },
    {
      'title': 'Notification',
      'icon': CupertinoIcons.bell_solid,
      'page': Activities(),
      'index': 3,
    },
    {
      'title': 'Profile',
      'icon': CupertinoIcons.person,
      'page': Profile(profileId: firebaseAuth.currentUser.uid),
      'index': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            _createHeader(),
            ListTile(
              title: Text('Travel'),
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => TravelPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Coaching'),
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => CoachingPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Driver'),
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => DriverPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Market Place'),
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => MarketPlacePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_page]['page'],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            for (Map item in pages)
              item['index'] == 2
                  ? buildFab()
                  : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: IconButton(
                        icon: Icon(
                          item['icon'],
                          color: item['index'] != _page
                              ? Colors.grey
                              : Constants.lightButtom,
                          size: 20.0,
                        ),
                        onPressed: () => navigationTapped(item['index']),
                      ),
                    ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Constants.lightButtom,
        // image: DecorationImage(
        //   fit: BoxFit.cover,
        //   image: AssetImage('assets/images/N9fondo_oscuro.png'),
        // ),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/Isotipo.png',
                  width: 95.0,
                  height: 95.0,
                ),
                Text(
                  "Nine Level beta 6",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "v1.0.0",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildFab() {
    return Container(
      height: 45.0,
      width: 45.0,
      // ignore: missing_required_param
      child: FabContainer(
        // page: Publication(),
        icon: Feather.plus,
        mini: true,
      ),
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}
