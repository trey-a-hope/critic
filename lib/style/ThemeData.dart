import 'package:critic/extensions/HexColor.dart';
import 'package:flutter/material.dart';

final String fontFamily = 'Montserrat';

ThemeData themeData = ThemeData(
  primaryColor: Colors.red,
  accentColor: Colors.red,

  fontFamily: fontFamily,

  // scaffoldBackgroundColor: Colors.white,
  // brightness: Brightness.light,
  // accentColor: Colors.red,
  accentIconTheme: IconThemeData(color: Colors.white),
  accentTextTheme: TextTheme(
    body1: TextStyle(color: Colors.white, fontSize: 20),
    body2: TextStyle(color: Colors.white, fontSize: 15),
    button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    headline: TextStyle(
        color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
    display1: TextStyle(
        color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
    subtitle: TextStyle(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
    title: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  // floatingActionButtonTheme: FloatingActionButtonThemeData(
  //     backgroundColor: Colors.blue, elevation: 4.0),
  // primaryColor: Colors.blue,
  // primaryIconTheme: IconThemeData(color: Colors.red[700]),
  // primaryTextTheme: TextTheme(
  //   body1: TextStyle(color: Colors.black, fontSize: 20),
  //   body2: TextStyle(color: Colors.black, fontSize: 15),
  //   button: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //   headline: TextStyle(
  //       color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
  //   display1: TextStyle(
  //       color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
  //   subtitle: TextStyle(
  //       color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
  //   title: TextStyle(
  //       color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  // ),
  // buttonTheme: ButtonThemeData(
  //     buttonColor: Colors.amber, textTheme: ButtonTextTheme.normal),
 // E83F3F
  buttonColor: HexColor("E83F3F"),

  // textTheme: TextTheme(
  //     headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  //     title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  //     body1: TextStyle(fontSize: 14.0, fontFamily: fontFamily),
  //   ),
);
