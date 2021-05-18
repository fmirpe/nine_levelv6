import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nine_levelv6/components/life_cycle_event_handler.dart';
import 'package:nine_levelv6/landing/landing_page.dart';
import 'package:nine_levelv6/screens/mainscreen.dart';
import 'package:nine_levelv6/services/user_service.dart';
import 'package:nine_levelv6/utils/config.dart';
import 'package:nine_levelv6/utils/constants.dart';
import 'package:nine_levelv6/utils/providers.dart';
import 'package:provider/provider.dart';

void main() async {
  //runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
  runApp(MyApp());
  //}, (Object error, StackTrace stack) {
  //  print(error);
  //print(stack);
  //});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      detachedCallBack: () => UserService().setUserStatus(false),
      resumeCallBack: () => UserService().setUserStatus(true),
    ));
  }

  @override
  void dispose() {
    UserService().setUserStatus(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  return TabScreen();
                } else
                  return Landing();
              },
            ),
          );
        },
      ),
    );
  }
}
