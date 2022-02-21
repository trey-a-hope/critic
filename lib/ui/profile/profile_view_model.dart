import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/user_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileViewModel extends GetxController {
  /// Instantiate user service.
  final UserService _userService = Get.find();

  /// The id of the user.
  final String uid = Get.arguments['uid'];

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// The user of this profile.
  UserModel? user;

  @override
  void onInit() async {
    super.onInit();

    // Fetch the current user.
    user = await _userService.retrieveUser(uid: uid);

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
}
