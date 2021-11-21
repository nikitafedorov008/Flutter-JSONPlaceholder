import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/users_page.dart';

/*
     ___  _______  _______  __    _  _______  ___      _______  _______  _______  __   __  _______  ___      ______   _______  ______
    |   ||       ||       ||  |  | ||       ||   |    |   _   ||       ||       ||  | |  ||       ||   |    |      | |       ||    _ |
    |   ||  _____||   _   ||   |_| ||    _  ||   |    |  |_|  ||       ||    ___||  |_|  ||   _   ||   |    |  _    ||    ___||   | ||
    |   || |_____ |  | |  ||       ||   |_| ||   |    |       ||       ||   |___ |       ||  | |  ||   |    | | |   ||   |___ |   |_||_
 ___|   ||_____  ||  |_|  ||  _    ||    ___||   |___ |       ||      _||    ___||       ||  |_|  ||   |___ | |_|   ||    ___||    __  |
|       | _____| ||       || | |   ||   |    |       ||   _   ||     |_ |   |___ |   _   ||       ||       ||       ||   |___ |   |  | |
|_______||_______||_______||_|  |__||___|    |_______||__| |__||_______||_______||__| |__||_______||_______||______| |_______||___|  |_|
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Color(0xff1f1f1f);
  static Color lightAccent = Colors.blue;
  static Color darkAccent = Colors.lightBlue;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Color(0xff121212);
  static Color badgeColor = Colors.red;

  static String appName = 'JSONPlaceholderAPI';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        backgroundColor: lightBG,
        primaryColor: lightPrimary,
        accentColor: lightAccent,
        cursorColor: lightAccent,
        scaffoldBackgroundColor: lightBG,
        appBarTheme: AppBarTheme(
          elevation: 0,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: darkBG,
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: darkBG,
        primaryColor: darkPrimary,
        accentColor: darkAccent,
        scaffoldBackgroundColor: darkBG,
        cursorColor: darkAccent,
        appBarTheme: AppBarTheme(
          elevation: 0,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: lightBG,
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      home: Users(),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}
