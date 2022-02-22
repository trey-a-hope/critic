import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/follow_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileViewModel extends GetxController {
  /// Instantiate user service.
  final UserService _userService = Get.find();

  /// Instantiate follow service.
  final FollowService _followService = Get.find();

  /// The id of the user.
  final String uid = Get.arguments['uid'];

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// The user of this profile.
  UserModel? user;

  /// Flag true if I am following the user of this profile, (only used when isMyProfile is false).
  bool isFollowing = false;

  @override
  void onInit() async {
    super.onInit();

    // Fetch the current user.
    user = await _userService.retrieveUser(uid: uid);

    // Determine if user a is following user b.
    isFollowing = await _followService.AisFollowingB(
        userAuid: _getStorage.read('uid'), userBuid: uid);

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

  /// Determines if the current profile is mine or of another person.
  bool get isMyProfile => _getStorage.read('uid') == uid;

  /// Follow the user of this profile.
  void follow() async {
    // Follow this user.
    await _followService.followAtoB(
        userAuid: _getStorage.read('uid'), userBuid: uid);

    // Determine if user a is following user b.
    isFollowing = await _followService.AisFollowingB(
        userAuid: _getStorage.read('uid'), userBuid: uid);

    // Fetch the current user.
    user = await _userService.retrieveUser(uid: uid);

    update();
  }

  /// Unfollow the user of this profile.
  void unfollow() async {
    // Unfollow this user.
    await _followService.unfollowAtoB(
        userAuid: _getStorage.read('uid'), userBuid: uid);

    // Determine if user a is following user b.
    isFollowing = await _followService.AisFollowingB(
        userAuid: _getStorage.read('uid'), userBuid: uid);

    // Fetch the current user.
    user = await _userService.retrieveUser(uid: uid);

    update();
  }
}
