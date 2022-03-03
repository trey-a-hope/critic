import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/stream_feed_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/util_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_version/new_version.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainViewModel extends GetxController {
  /// Firebase auth instance.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Firebase messaging instance.
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Firebase user observable.
  Rxn<User> firebaseUser = Rxn<User>();

  /// Firestore user observable.
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();

  /// Users database collection reference.
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('users');

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Instantiate user service.
  UserService _userService = Get.find();

  /// Instantiate util service.
  UtilService _utilService = Get.find();

  /// Instance of new version class.
  final NewVersion _newVersion = NewVersion();

  @override
  void onReady() async {
    // Run every time auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);

    super.onReady();
  }

  /// Listens for user auth changes.
  handleAuthChanged(_firebaseUser) async {
    // Proceed to Login Page if user is not logged in or there's a new version of the app.
    final VersionStatus? status = await _newVersion.getVersionStatus();
    if (_firebaseUser == null || (status != null && status.canUpdate)) {
      Get.offAllNamed(Globals.ROUTES_LOGIN);
    }
    // Proceed to home page.
    else {
      // Get user document reference.
      DocumentReference userDocRef = _usersDB.doc(_firebaseUser.uid);

      // Check if user already exists.
      bool userExists = (await userDocRef.get()).exists;

      // Set UID to get storage.
      await _getStorage.write('uid', _firebaseUser.uid);

      // Set app version and build number.
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _getStorage.write(Globals.APP_BUILD_NUMBER, packageInfo.buildNumber);
      _getStorage.write(Globals.APP_VERSION, packageInfo.version);

      // Bind Stream Feed Service after uid is determined.
      Get.lazyPut(() => StreamFeedService(), fenix: true);

      // Records a user ID (identifier) that's associated with subsequent fatal and non-fatal reports.
      await FirebaseCrashlytics.instance.setUserIdentifier(_firebaseUser.uid);

      if (userExists) {
        // Request permission from user to receive push notifications.
        if (Platform.isIOS) {
          _firebaseMessaging.requestPermission();
        }

        // Fetch the fcm token for this device.
        String? token = await _firebaseMessaging.getToken();

        // Validate that it's not null.
        assert(token != null);

        // Update fcm token for this device in firebase.
        userDocRef.update({'fcmToken': token});
      } else {
        // Create user in firebase.
        UserModel newUser = UserModel(
          imgUrl: _firebaseUser.photoURL ?? Globals.DUMMY_PROFILE_PHOTO_URL,
          created: DateTime.now().toUtc(),
          modified: DateTime.now().toUtc(),
          uid: _firebaseUser.uid,
          username: _firebaseUser.displayName ?? 'I NEED A NAME',
          email: _firebaseUser.email ?? '',
          isOnline: true,
          showAds: true,
          watchList: [],
          blockedUsers: [],
        );

        await _userService.createUser(user: newUser);
      }

      // Set user online status to true.
      await _utilService.setOnlineStatus(isOnline: true);

      // Proceed to home page.
      Get.offAllNamed(Globals.ROUTES_HOME);
    }
  }

  // Firebase user a realtime stream.
  Stream<User?> get user => _auth.authStateChanges();
}
