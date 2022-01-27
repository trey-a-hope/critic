import 'package:critic/pages/entry_page.dart';
import 'package:critic/style/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'constants.dart';
import 'service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:critic/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase.
  await Firebase.initializeApp();

  //Initialize services.
  setUpLocater();

  //Set package info.
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  //Initialize Hive.
  await Hive.initFlutter();

  //Open hive boxes.
  await Hive.openBox<String>(HIVE_BOX_LOGIN_CREDENTIALS);

  //Set status bar color.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ),
  );

  //Set screen orientation.
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  State createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  MyAppState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Critic',
      theme: themeData,
      themeMode: ThemeMode.dark,
      darkTheme: darkThemeData,
      home: StreamBuilder(
        stream: locator<AuthService>().onAuthStateChanged(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          screenWidth = MediaQuery.of(context).size.width;
          screenHeight = MediaQuery.of(context).size.height;
          return snapshot.hasData
              ? EntryPage(myAppState: this)
              : BlocProvider<LoginBloc>(
                  create: (BuildContext context) => LoginBloc(),
                  child: LoginPage(),
                );
        },
      ),
    );
  }
}
