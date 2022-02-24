import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/fcm_notification_service.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CritiqueWidgetViewModel extends GetxController {
  CritiqueWidgetViewModel({required this.critique});

  /// The critique.
  CritiqueModel critique;

  /// The movie associated with this critique.
  late MovieModel movie;

  /// The user who posted this critique.
  late UserModel user;

  /// Current user of the app.
  late UserModel currentUser;

  /// FCM service instance.
  final FCMNotificationService _fcmNotificationService = Get.find();

  /// Instantiate movie service.
  final MovieService _movieService = Get.find();

  /// Instantiate user service.
  final UserService _userService = Get.find();

  /// Critique service instance.
  final CritiqueService _critiqueService = Get.find();

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Indicator of page loading or not.
  bool _isLoading = true;

  @override
  void onInit() async {
    super.onInit();

    // Fetch the movie for this critique.
    movie = await _movieService.getMovieByID(id: critique.imdbID);

    // Fetch the user who posted this critique.
    user = await _userService.retrieveUser(uid: critique.uid);

    // Fetch the current user of the app.
    currentUser = await _userService.retrieveUser(uid: _getStorage.read('uid'));

    // Turn loading indicator off.
    _isLoading = false;

    update();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  bool get isLoading => _isLoading;

  bool get isLiked => critique.likes.contains(_getStorage.read('uid'));

  bool get postedByMe => _getStorage.read('uid') == user.uid;

  Future<bool> deleteCritique() async {
    try {
      /// Delete the critique.
      await _critiqueService.delete(
        uid: user.uid,
        activityID: critique.activityID!,
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> likeCritique() async {
    try {
      // Like the critique.
      await _critiqueService.like(
        uid: _getStorage.read('uid'),
        activityID: critique.activityID!,
      );

      // Notify user their critique has been liked.
      if (user.fcmToken != null) {
        _fcmNotificationService.sendNotificationToUser(
          fcmToken: user.fcmToken!,
          title: '${currentUser.username} liked your critique.',
          body: 'Ebert and Roeper would be proud.',
          notificationData: null,
        );
      }

      /// Fetch updated critique.
      critique =
          await _critiqueService.retrieve(activityID: critique.activityID);

      update();

      return;
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  Future<void> unlikeCritique() async {
    try {
      /// Unlike the critique.
      await _critiqueService.unlike(
        uid: _getStorage.read('uid'),
        activityID: critique.activityID!,
      );

      /// Fetch updated critique.
      critique =
          await _critiqueService.retrieve(activityID: critique.activityID);

      update();

      return;
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }
}
