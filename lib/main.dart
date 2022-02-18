import 'package:critic/constants.dart';
import 'package:critic/services/util_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import 'constants/app_routes.dart';
import 'constants/app_themes.dart';
import 'initialize_dependencies.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Wait for firebase app to initialize.
  await Firebase.initializeApp();

  /// Set version and build numbers.
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  /// Initialize Hive.
  await Hive.initFlutter();

  /// Open hive boxes.
  await Hive.openBox<String>(HIVE_BOX_LOGIN_CREDENTIALS);

  /// Set status bar color to black.
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

  static final Box<dynamic> _userCredentialsBox =
      Hive.box<String>(HIVE_BOX_LOGIN_CREDENTIALS);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String? uid = _userCredentialsBox.get('uid');
    if (state == AppLifecycleState.resumed) {
      locator<UtilService>().setOnlineStatus(isOnline: true);
    } else {
      locator<UtilService>().setOnlineStatus(isOnline: false);
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
