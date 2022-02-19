import 'package:critic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UtilService extends GetxService {
  /// Instantiate user service.
  final UserService _userService = Get.find();

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  void heroToImage({
    required BuildContext context,
    required String imgUrl,
    required String tag,
  }) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(imgUrl: imgUrl, tag: tag);
    }));
  }

  Future<void> setOnlineStatus({required bool isOnline}) async {
    String? uid = _getStorage.read('uid');

    if (uid == null) return;

    await _userService.updateUser(
      uid: uid,
      data: {'isOnline': isOnline},
    );

    return;
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen({required this.tag, required this.imgUrl});

  final String tag;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: tag,
            child: Image.network(
              imgUrl,
            ),
          ),
        ),
      ),
    );
  }
}
