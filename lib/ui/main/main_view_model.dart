import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/util_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../constants.dart';
import '../../initialize_dependencies.dart';

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

  /// No sql database for storing uid and other credentials.
  static final Box<dynamic> _userCredentialsBox =
      Hive.box<String>(HIVE_BOX_LOGIN_CREDENTIALS);

  /// Instantiate user service.
  UserService _userService = Get.find();

  /// Instantiate util service.
  UtilService _utilService = Get.find();

  @override
  void onReady() async {
    /// Run every time auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);

    super.onReady();
  }

  handleAuthChanged(_firebaseUser) async {
    /// Proceed to Login Page if user is null.
    if (_firebaseUser == null) {
      Get.offAllNamed("/login");
    } else {
      /// Get user document reference.
      DocumentReference userDocRef = _usersDB.doc(_firebaseUser.uid);

      //Check if user already exists.
      bool userExists = (await userDocRef.get()).exists;

      //Set UID to hive box.
      _userCredentialsBox.put('uid', _firebaseUser.uid);

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
      } else {
        //Create user in firebase
        UserModel newUser = UserModel(
          imgUrl: _firebaseUser.photoURL ?? DUMMY_PROFILE_PHOTO_URL,
          created: DateTime.now(),
          modified: DateTime.now(),
          uid: _firebaseUser.uid,
          username: _firebaseUser.displayName ?? 'John Doe',
          critiqueCount: 0,
          email: _firebaseUser.email!,
        );

        await _userService.createUser(user: newUser);
      }

      /// Set user online status to true.
      _utilService.setOnlineStatus(isOnline: true);

      /// Proceed to home page.
      Get.offAllNamed("/home");
    }
  }

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();
}
