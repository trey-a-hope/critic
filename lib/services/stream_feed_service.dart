import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:critic/constants/globals.dart';
import 'package:get/get.dart';
import 'package:stream_feed/stream_feed.dart';

class StreamFeedService extends GetxService {
  StreamFeedService({required this.uid});

  /// UID of current user.
  final String uid;

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

  void onInit() {
    /// Create front end token via uid.
    final Token _userToken = _streamFeedClient.frontendToken(uid);

    /// Set the user token for the client.
    _client.setUser(User(id: uid), _userToken);

    super.onInit();
  }

  /// Adds the given [Activity] to the feed parameters: [activity] : The activity to add
  Future<String> addActivity() async {
    final Activity activity = Activity(
      actor: 'SU:${uid}',
      verb: 'post',
      object: '1',
    );

    Activity addedActivity =
        await _client.flatFeed('users', uid).addActivity(activity);

    return addedActivity.id!;
  }

  /// Retrieve activities
  Future<List<Activity>> getActivities() async {
    return await _client.flatFeed('users', uid).getActivities(limit: 10);
  }

  /// Removes the activity by activityId or foreignId parameters [id] : activityId Identifier of activity to remove
  Future<void> removeActivity({required String activityID}) async {
    return await _client.flatFeed('users', uid).removeActivityById(activityID);
  }
}
