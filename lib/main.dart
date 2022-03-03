import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'constants/app_routes.dart';
import 'constants/app_themes.dart';
import 'initialize_dependencies.dart';
import 'package:get/get.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for firebase app to initialize.
  await Firebase.initializeApp();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Initialize Get Storage.
  await GetStorage.init();

  // Set status bar color to black.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ),
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  MyApp({Key? key}) : super(key: key);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //TODO:
      // locator<UtilService>().setOnlineStatus(isOnline: true);
    } else {
      // locator<UtilService>().setOnlineStatus(isOnline: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Critic',
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent,
        textTheme: AppThemes.textTheme,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      initialBinding: InitialBinding(),
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}
