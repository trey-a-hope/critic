import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/auth_service.dart';
import 'package:get/get.dart';

class DrawerViewModel extends GetxController {
  /// Current user.
  UserModel? user;

  /// Instantiate auth service.
  AuthService _authService = Get.find();

  @override
  void onInit() async {
    /// Fetch the current user.
    user = await _authService.getCurrentUser();

    update();

    super.onInit();
  }
}
