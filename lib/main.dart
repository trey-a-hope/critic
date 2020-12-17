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
import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

//Prepare services.
  setUpLocater();

//Assign package info.
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDarkModeEnabled = prefs.getBool('isDarkModeEnabled') ?? false;

  runApp(
    MyApp(isDarkModeEnabled: isDarkModeEnabled),
  );
}

class MyApp extends StatefulWidget {
  final bool isDarkModeEnabled;
  MyApp({@required this.isDarkModeEnabled});

  @override
  State createState() => MyAppState(isDarkModeEnabled: isDarkModeEnabled);
}

class MyAppState extends State<MyApp> {
  MyAppState({@required this.isDarkModeEnabled});

  bool isDarkModeEnabled;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

    return MaterialApp(
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
