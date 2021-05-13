import 'package:animations/animations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nine_levelv6/chats/recent_chats.dart';
import 'package:nine_levelv6/components/fab_container.dart';
import 'package:nine_levelv6/pages/coaching.dart';
import 'package:nine_levelv6/pages/driver.dart';
import 'package:nine_levelv6/pages/marketplace.dart';
import 'package:nine_levelv6/pages/notification.dart';
import 'package:nine_levelv6/pages/profile.dart';
import 'package:nine_levelv6/pages/search.dart';
import 'package:nine_levelv6/pages/feeds.dart';
import 'package:nine_levelv6/pages/travel.dart';
import 'package:nine_levelv6/screens/callscreens/pickup/pickup_layout.dart';
import 'package:nine_levelv6/utils/constants.dart';
import 'package:nine_levelv6/utils/firebase.dart';
import 'package:nine_levelv6/view_models/user/user_view_model.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _page = 0;
  String version = "1.0.0";
  String buildVersion = "7";

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool confignotification = false;

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
  void initState() {
    super.initState();
    cargaDatos();

    if (!confignotification) {
      registerNotification();
      configLocalNotification();
    }
  }

  void configLocalNotification() {
    print('configLocalNotification');
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(payload) async {
    print('onSelectNotification');
    // Fluttertoast.showToast(
    //     msg: "New Message",
    //     durationTime: 5,
    //     textColor: Colors.black,
    //     backgroundColor: Colors.white);
    // if (listmessage != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chats(),
      ),
    );
    // }
  }

  void registerNotification() {
    print('registerNotification');
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      //_showNotificationWithDefaultSound(message['notification']);
      final authService = Provider.of<UserViewModel>(context, listen: false);
      //String peerId = message['data']['peerId'];
      //String peerAvatar = message['data']['peerPhotoUrl'];
      print(firebaseAuth.currentUser.uid);
      print('Mensaje');

      _showNotificationWithDefaultSound(message);

      // Platform.isAndroid
      //     ? showNotification(message['notification'])
      //     : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    // firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
    // firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });

    firebaseMessaging.getToken().then((token) {
      final authService = Provider.of<UserViewModel>(context, listen: false);
      print('token: $token');
      authService.updateToken(token);
    });
  }

  void _showNotificationWithDefaultSound(message) async {
    print('_showNotificationWithDefaultSound');
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'n9b6', 'N9-Chat', 'Chat Nine Level Beta 6',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'].toString(),
      message['notification']['body'].toString(),
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );

    print('Fin _showNotificationWithDefaultSound');
  }

  cargaDatos() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    //String appName = packageInfo.appName;
    //String packageName = packageInfo.packageName;
    print(packageInfo.version);
    print(packageInfo.buildNumber);
    version = packageInfo.version;
    buildVersion = packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
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
                  "v$version+$buildVersion",
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
