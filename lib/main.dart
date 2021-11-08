import 'dart:io';

import 'package:critic/pages/entry_page.dart';
import 'package:critic/style/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Constants.dart';
import 'service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'blocs/web/web_bloc.dart' as WEB_BP;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:critic/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;

  //Initialize Hive.
  await Hive.initFlutter();

  //Open hive boxes.
  await Hive.openBox<String>(HIVE_BOX_LOGIN_CREDENTIALS);

  runApp(
    MyApp(
      isDarkModeEnabled: isDarkModeEnabled,
      isWeb: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isDarkModeEnabled;
  final bool isWeb;

  MyApp({
    required this.isDarkModeEnabled,
    required this.isWeb,
  });

  @override
  State createState() => MyAppState(
        isDarkModeEnabled: isDarkModeEnabled,
        isWeb: isWeb,
      );
}

class MyAppState extends State<MyApp> {
  MyAppState({
    required this.isDarkModeEnabled,
    required this.isWeb,
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
                screenWidth = MediaQuery.of(context).size.width;
                screenHeight = MediaQuery.of(context).size.height;
                return !snapshot.hasData
                    ? BlocProvider<LoginBloc>(
                        create: (BuildContext context) => LoginBloc(),
                        child: LoginPage(),
                      )
                    : EntryPage(myAppState: this);
              },
            ),
          );
  }
}
