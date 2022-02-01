import 'package:critic/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service_locator.dart';

abstract class IUtilService {
  void heroToImage({
    required BuildContext context,
    required String imgUrl,
    required String tag,
  });
  void setOnlineStatus({required bool isOnline});
}

class UtilService extends IUtilService {
  @override
  void heroToImage({
    required BuildContext context,
    required String imgUrl,
    required String tag,
  }) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(imgUrl: imgUrl, tag: tag);
    }));
  }

  @override
  Future<void> setOnlineStatus({required bool isOnline}) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await locator<UserService>().updateUser(
      uid: user.uid,
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
