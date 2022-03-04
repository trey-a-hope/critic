import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:critic/constants/globals.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stream_feed/stream_feed.dart';

class StreamFeedService extends GetxService {
  StreamFeedService();

  /// Create Stream Feed Client.
  static StreamFeedClient _streamFeedClient = StreamFeedClient(
    Globals.STREAM_API_KEY,
    secret: Globals.STREAM_API_SECRET,
    runner: Runner.server,
    appId: Globals.STREAM_API_APP_ID,
    options: StreamHttpClientOptions(
      location: Location.usEast,
      connectTimeout: Duration(seconds: 15),
    ),
  );

  /// Instantiate new client.
  final StreamFeedClient _client = StreamFeedClient(Globals.STREAM_API_KEY);

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  void onInit() {
    super.onInit();

    /// Create front end token via uid.
    final Token _userToken = _streamFeedClient.frontendToken(
      _getStorage.read('uid'),
      expiresAt: DateTime.now().add(
        Duration(days: 1),
      ),
    );

    /// Set the user token for the client.
    _client.setUser(User(id: _getStorage.read('uid')), _userToken);
  }

  /// Adds the given [Activity] to the feed parameters: [activity] : The activity to add
  Future<String> addActivity() async {
    final Activity activity = Activity(
      actor: 'SU:${_getStorage.read('uid')}',
      verb: 'post',
      object: '1',
    );

    Activity addedActivity = await _streamFeedClient
        .flatFeed('users', _getStorage.read('uid'))
        .addActivity(activity);

    return addedActivity.id!;
  }

  /// Retrieve activities
  Future<List<Activity>> getActivities({
    required int limit,
    required int offset,
  }) async {
    List<Activity> activities = await _streamFeedClient
        .flatFeed('users', _getStorage.read('uid'))
        .getActivities(
          limit: limit,
          offset: offset,
        );
    return activities;
  }

  /// Removes the activity by activityId or foreignId parameters [id] : activityId Identifier of activity to remove
  Future<void> removeActivity(
      {required String uid, required String activityID}) async {
    return await _streamFeedClient
        .flatFeed('users', uid)
        .removeActivityById(activityID);
  }

  /// Follow a feed.
  Future<void> followFeed({required String feedToFollowUID}) async {
    await _streamFeedClient.flatFeed('users', _getStorage.read('uid')).follow(
          _streamFeedClient.flatFeed(
            'users',
            feedToFollowUID,
          ),
        );
  }

  /// Unfollow a feed.
  Future<void> unfollowFeed({required String feedToUnfollowUID}) async {
    await _streamFeedClient.flatFeed('users', _getStorage.read('uid')).unfollow(
          _streamFeedClient.flatFeed(
            'users',
            feedToUnfollowUID,
          ),
        );
  }

  /// Get follower count.
  Future<int> followerCount({required String uuid}) async {
    FollowStats followStats =
        await _streamFeedClient.flatFeed('users', uuid).followStats();

    return followStats.followers.count!;
  }

  /// Get followings count.
  Future<int> followingCount({required String uuid}) async {
    FollowStats followStats =
        await _streamFeedClient.flatFeed('users', uuid).followStats();

    return followStats.following.count!;
  }

  /// Return true if user is following this account.
  Future<bool> isFollowing({required String uuid}) async {
    List<Follow> follows = await _streamFeedClient
        .flatFeed('users', _getStorage.read('uid'))
        .following(filter: [FeedId.id('users:${uuid}')]);

    return follows.isNotEmpty;
  }

  /// Return list of uids that are following this account.
  Future<List<String>> getFollowerUids({required String uuid}) async {
    List<Follow> followers =
        await _streamFeedClient.flatFeed('users', uuid).followers();

    List<String> uids = [];

    for (int i = 0; i < followers.length; i++) {
      // Extract user id from feed id.
      String followerUid = followers[i].feedId.replaceAll('users:', '');

      uids.add(followerUid);
    }

    return uids;
  }

  /// Return list of uids this account is following.
  Future<List<String>> getFollowingUids({required String uuid}) async {
    List<Follow> followings =
        await _streamFeedClient.flatFeed('users', uuid).following();

    List<String> uids = [];

    for (int i = 0; i < followings.length; i++) {
      // Extract user id from feed id.
      String followingUid = followings[i].targetId.replaceAll('users:', '');

      uids.add(followingUid);
    }

    return uids;
  }
}
