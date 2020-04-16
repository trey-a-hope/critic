import 'package:critic/pages/EntryPage.dart';
import 'package:critic/pages/HomePage.dart';
import 'package:critic/pages/LoginPage.dart';
import 'package:critic/pages/myhomepage.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/style/ThemeData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'dart:ui' as ui;
import 'package:package_info/package_info.dart';

import 'Constants.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  //Call this at the beginning of main().
  WidgetsFlutterBinding.ensureInitialized();

  //Register dependencies.
  getIt.registerSingleton<IMovieService>(MovieService(), signalsReady: true);
  getIt.registerSingleton<IAuthService>(AuthService(), signalsReady: true);
  getIt.registerSingleton<IValidationService>(ValidationService(),
      signalsReady: true);
  getIt.registerSingleton<IModalService>(ModalService(), signalsReady: true);
  getIt.registerSingleton<IUserService>(UsersService(), signalsReady: true);
  getIt.registerSingleton<ICritiqueService>(CritiqueService(), signalsReady: true);
  getIt.registerSingleton<IStorageService>(StorageService(), signalsReady: true);

    //Assign app version and build number.
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

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
      home: StreamBuilder(
        stream: getIt<IAuthService>().onAuthStateChanged(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final FirebaseUser firebaseUser = snapshot.data;

          //If user is logged in...
          if (firebaseUser != null) return EntryPage();

          return LoginPage();
        },
      ),
    );
  }
}
