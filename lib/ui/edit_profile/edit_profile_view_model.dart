import 'dart:io';

import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/storage_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileViewModel extends GetxController {
  /// Instantiate user service.
  final UserService _userService = Get.find();

  /// Storage service instance.
  final StorageService _storageService = Get.find();

  /// Id of user that is editing their profile.
  final String uid = Get.arguments['uid'];

  UserModel? user;

  @override
  void onInit() async {
    super.onInit();

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

  /// Save form.
  Future<bool> save({required String username}) async {
    try {
      // Update user.
      await _userService.updateUser(
        uid: uid,
        data: {'username': username},
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void updateImage({required ImageSource imageSource}) async {
    try {
      XFile? file = await ImagePicker().pickImage(source: imageSource);

      if (file == null) return;

      File? image = await ImageCropper.cropImage(sourcePath: file.path);

      if (image == null) return;

      final String newImgUrl = await _storageService.uploadImage(
        file: image,
        imgPath: 'Images/Users/$uid/Profile',
      );

      await _userService.updateUser(
        uid: uid,
        data: {
          'imgUrl': newImgUrl,
        },
      );

      user = await _userService.retrieveUser(uid: uid);

      update();
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
