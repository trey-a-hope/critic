import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/user_service.dart';
import 'package:get/get.dart';

import '../../constants/globals.dart';

class UsersListViewModel extends GetxController {
  /// User service instance.
  final UserService _userService = Get.find();

  /// Title of the page.
  final String title = Get.arguments['title'];

  /// List of uids for each user.
  final List<String> uids = Get.arguments['uids'];

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  /// Returns a paginated list of users.
  Future<List<UserModel>> fetchUsers(int offset) async {
    List<UserModel> users = [];

    for (int i = offset;
        (i < uids.length) && (i < (offset + Globals.USERS_PAGE_FETCH_LIMIT));
        i++) {
      users.add(await _userService.retrieveUser(uid: uids[i]));
    }

    if (users.isEmpty) return users;

    return users;
  }
}
