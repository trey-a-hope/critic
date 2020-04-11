import 'package:critic/pages/HomePage.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/style/ThemeData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'dart:ui' as ui;

final GetIt getIt = GetIt.instance;

void main() {
  //Widgets Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  //Register Dependency Injections
  getIt.registerSingleton<IMovieService>(MovieService(), signalsReady: true);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Critic',
      theme: themeData,
      home: HomePage()
    );
  }
}
