import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/pages/entry_page.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/util_service.dart';
import 'package:critic/style/theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info/package_info.dart';
import 'constants.dart';
import 'models/data/user_model.dart';
import 'service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  MyAppState();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');

  late Stream<User?> stream;

  @override
  void initState() {
    super.initState();

    //Build stream for listening to user authentication states.
    stream = FirebaseAuth.instance.authStateChanges().asyncMap(
          (user) => authStateChangesAsyncStream(user: user),
        );
  }

  Future<User?> authStateChangesAsyncStream({required User? user}) async {
    if (user == null) return user;

    DocumentReference userDocRef = _usersDB.doc(user.uid);

    //Check if user already exists.
    bool userExists = (await userDocRef.get()).exists;

    if (userExists) {
      //Request permission from user.
      if (Platform.isIOS) {
        _firebaseMessaging.requestPermission();
      }

      //Fetch the fcm token for this device.
      String? token = await _firebaseMessaging.getToken();

      //Validate that it's not null.
      assert(token != null);

      //Update fcm token for this device in firebase.
      userDocRef.update({'fcmToken': token});

      return user;
    }

    //Create user in firebase
    UserModel newUser = UserModel(
      imgUrl: user.photoURL ?? DUMMY_PROFILE_PHOTO_URL,
      created: DateTime.now(),
      modified: DateTime.now(),
      uid: user.uid,
      username: user.displayName ?? 'John Doe',
      critiqueCount: 0,
      email: user.email!,
    );

    await locator<UserService>().createUser(user: newUser);

    return user;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      locator<UtilService>().setOnlineStatus(isOnline: true);
    } else {
      locator<UtilService>().setOnlineStatus(isOnline: false);
    }
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
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  ),
                );
              } else if (!snapshot.hasData) {
                //Send user to login page.
                return BlocProvider<LoginBloc>(
                  create: (BuildContext context) => LoginBloc(),
                  child: LoginPage(),
                );
              } else {
                //Set user to online status.
                locator<UtilService>().setOnlineStatus(isOnline: true);

                //Proceed to app.
                return EntryPage(myAppState: this);
              }
          }
        },
      ),
    );
  }
}
