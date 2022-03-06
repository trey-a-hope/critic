import 'dart:async';
import 'package:get/get.dart';
import '../../constants/globals.dart';

class SplashViewModel extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    // Proceed to main page after 3 seconds.
    Timer(
      Duration(seconds: 3),
      () => Get.toNamed(Globals.ROUTES_MAIN),
    );
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }
}
