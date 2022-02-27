import 'package:critic/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final String fontFamily = 'Montserrat';

ThemeData darkThemeData = ThemeData(
  textTheme: TextTheme(
    headline3: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 21,
    ),
    headline4: TextStyle(
        color: Colors.grey.shade200, fontSize: 16, fontWeight: FontWeight.bold),
    headline5: TextStyle(
        color: Colors.grey.shade200, fontSize: 14, fontWeight: FontWeight.bold),
    headline6: TextStyle(color: Colors.white, fontSize: 14),
  ),
  indicatorColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.white),
  appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
  scaffoldBackgroundColor: const Color(0xFF15202B),
  fontFamily: fontFamily,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF253341),
  ),
  canvasColor: const Color(0xFF253341),
  dividerColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Color(0xFF253341),
      ),
    ),
  ),
  cardColor: const Color(0xFF253341),
);

ThemeData themeData = ThemeData(
  textTheme: TextTheme(
    headline3: TextStyle(
      color: Globals.colorNavy,
      fontWeight: FontWeight.bold,
      fontSize: 21,
    ),
    headline4: TextStyle(
        color: Colors.grey.shade800, fontSize: 16, fontWeight: FontWeight.bold),
    headline5: TextStyle(
        color: Colors.grey.shade800, fontSize: 14, fontWeight: FontWeight.bold),
    headline6: TextStyle(color: Globals.colorNavy, fontSize: 14),
  ),
  indicatorColor: Globals.colorNavy,
  iconTheme: IconThemeData(color: Globals.colorNavy),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  scaffoldBackgroundColor: Colors.white,
  fontFamily: fontFamily,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  canvasColor: Colors.white,
  dividerColor: const Color(0xFF253341),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Colors.red.shade900,
      ),
    ),
  ),
  cardColor: Colors.red.shade900,
);
