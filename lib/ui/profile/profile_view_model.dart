import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/stream_feed_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileViewModel extends GetxController {
  /// Instantiate user service.
  final UserService _userService = Get.find();

  /// Stream Feed service instance.
  final StreamFeedService _streamFeedService = Get.find();

  /// The id of the user.
  final String uid = Get.arguments['uid'];

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// The user of this profile.
  UserModel? user;

  /// Flag true if I am following the user of this profile, (only used when isMyProfile is false).
  bool isFollowing = false;

  /// Number of users following this profile.
  int followerCount = 0;

  /// Number of users this profile is following.
  int followingCount = 0;

  @override
  void onInit() async {
    super.onInit();

    user = await _userService.retrieveUser(uid: uid);

    await fetchStats();

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

  /// Updates follower count, following count, and if the user is following this profile.
  Future<void> fetchStats() async {
    followerCount = await _streamFeedService.followerCount(uuid: uid);

    followingCount = await _streamFeedService.followingCount(uuid: uid);

    isFollowing = await _streamFeedService.isFollowing(uuid: uid);
  }

  /// Determines if the current profile is mine or of another person.
  bool get isMyProfile => _getStorage.read('uid') == uid;

  /// Follow the user of this profile.
  void follow() async {
    // Follow the user feed in stream.
    await _streamFeedService.followFeed(feedToFollowUID: uid);

    await fetchStats();

    update();
  }

  /// Unfollow the user of this profile.
  void unfollow() async {
    // Unfollow the user feed in stream.
    await _streamFeedService.unfollowFeed(feedToUnfollowUID: uid);

    await fetchStats();

    update();
  }
}
