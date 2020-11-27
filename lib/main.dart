import 'package:critic/pages/EntryPage.dart';
import 'package:critic/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'Constants.dart';
import 'ServiceLocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/login/Bloc.dart' as LOGIN_BP;
import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }

  setUpLocater();

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
              : EntryPage();
        },
      ),
    );
  }
}
