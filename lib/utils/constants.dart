import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';

class Constants {
  //App related strings
  static String appName = "Nine Level";

  static String placeHolderImageRef = 'assets/images/user_placeholder.jpg';

  //Colors for theme
  static Color lightPrimary = Color(0xfff3f4f9);
  static Color darkPrimary = Color(0xff2B2B2B);

  static Color lightButtom = HexColor("#B11B3B");

  static Color gradianButtom = HexColor("#B11B3B");

  static Color lightAccent = Color(0xff886EE4);

  static Color darkAccent = Color(0xff886EE4);

  static Color lightBG = Color(0xfff3f4f9);
  static Color darkBG = Color(0xff2B2B2B);

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Lato-Regular',
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightButtom,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0,
      color: lightBG,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Lato-Regular',
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Lato-Regular',
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: lightButtom,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0,
      color: darkBG,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: lightBG,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Lato-Regular',
        ),
      ),
    ),
  );

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
}

class ThemeNotifier extends ChangeNotifier {
  final String key = 'theme';
  final String keyMute = 'muteVideo';
  SharedPreferences _prefs;
  bool _darkTheme;
  bool _muteVideo;
  bool get dark => _darkTheme;
  bool get muteVideo => _muteVideo;

  ThemeNotifier() {
    _darkTheme = false;
    _muteVideo = false;
    _loadfromPrefs();
  }
  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs(key);
    notifyListeners();
  }

  toggleMuteVideo() {
    _muteVideo = !_muteVideo;
    _saveToPrefs(keyMute);
    notifyListeners();
  }

  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadfromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? true;
    _muteVideo = _prefs.getBool(keyMute) ?? true;
    notifyListeners();
  }

  _saveToPrefs(String key) async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }
}
