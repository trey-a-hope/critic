import 'package:critic/services/stream_feed_service.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  /// Instantiate stream feed service.
  StreamFeedService _streamFeedService = Get.find();

  @override
  void onInit() async {
    super.onInit();
  }
}
