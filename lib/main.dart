import 'dart:io';

import 'package:critic/pages/EntryPage.dart';
import 'package:critic/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';
import 'ServiceLocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/login/Bloc.dart' as LOGIN_BP;
import 'blocs/web/Bloc.dart' as WEB_BP;

import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

//Prepare services.
  setUpLocater();

  bool isWeb;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      isWeb = false;
    } else {
      isWeb = true;
    }
  } catch (e) {
    isWeb = true;
  }

  if (!isWeb) {
    //Assign package info.
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;

  runApp(
    MyApp(
      isDarkModeEnabled: isDarkModeEnabled,
      isWeb: isWeb,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isDarkModeEnabled;
  final bool isWeb;

  MyApp({
    @required this.isDarkModeEnabled,
    @required this.isWeb,
  });

  @override
  State createState() => MyAppState(
        isDarkModeEnabled: isDarkModeEnabled,
        isWeb: isWeb,
      );
}

class MyAppState extends State<MyApp> {
  MyAppState({
    @required this.isDarkModeEnabled,
    @required this.isWeb,
  });

  bool isDarkModeEnabled;
  final bool isWeb;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    return isWeb
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Critic',
            theme: themeData,
            themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            darkTheme: darkThemeData,
            home: BlocProvider(
              create: (BuildContext context) =>
                  WEB_BP.WebBloc()..add(WEB_BP.LoadPageEvent()),
              child: WEB_BP.WebPage(),
            ),
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Critic',
            theme: themeData,
            themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            darkTheme: darkThemeData,
            home: StreamBuilder(
              stream: locator<AuthService>().onAuthStateChanged(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final User firebaseUser = snapshot.data;

                screenWidth = MediaQuery.of(context).size.width;
                screenHeight = MediaQuery.of(context).size.height;

                return firebaseUser == null
                    ? BlocProvider(
                        create: (BuildContext context) => LOGIN_BP.LoginBloc(),
                        child: LOGIN_BP.LoginPage(),
                      )
                    : EntryPage(myAppState: this);
              },
            ),
          );
  }
}
