import 'package:critic/style/ThemeData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'Constants.dart';
import 'ServiceLocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/login/Bloc.dart' as LoginBP;

void main() async {
  //Call this at the beginning of main().
  WidgetsFlutterBinding.ensureInitialized();

  setUpLocater();

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
        home: BlocProvider(
          create: (BuildContext context) => LoginBP.LoginBloc(),
          child: LoginBP.LoginPage(),
        )

        // StreamBuilder(
        //   stream: locator<AuthService>().onAuthStateChanged(),
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     final FirebaseUser firebaseUser = snapshot.data;
        //     return firebaseUser == null ? LoginPage() : EntryPage();
        //   },
        // ),
        );
  }
}
