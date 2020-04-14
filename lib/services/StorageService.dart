import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class IStorageService {
  Future<String> uploadImage({@required File file, @required String imgPath});
  Future<void> deleteImage({@required String imgPath});
}

class StorageService extends IStorageService {
  //Add validation to determine if file is image or not...
  @override
  Future<String> uploadImage(
      {@required File file, @required String imgPath}) async {
    try {
      final StorageReference ref = FirebaseStorage().ref().child(imgPath);
      final StorageUploadTask uploadTask = ref.putFile(file);
      StorageReference sr = (await uploadTask.onComplete).ref;
      return (await sr.getDownloadURL()).toString();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteImage({@required String imgPath}) async {
    try {
      final StorageReference ref = FirebaseStorage().ref().child(imgPath);
      await ref.delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}