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
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/UserService.dart';
// import 'package:critic/services/Userservice.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/GoodButton.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      // home: BlocProvider(
      //   create: (BuildContext context) => LoginBP.LoginBloc(),
      //   child: LoginBP.LoginPage(),
      // )

      home: StreamBuilder(
        stream: locator<AuthService>().onAuthStateChanged(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final FirebaseUser firebaseUser = snapshot.data;

          // Route route = MaterialPageRoute(
          //   builder: (BuildContext context) => BlocProvider(
          //     create: (BuildContext context) =>
          //         LOGIN_BP.LoginBloc(),
          //     child: LOGIN_BP.LoginPage(),
          //   ),
          // );

          // Navigator.push(
          //   context,
          //   route,
          // );

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
