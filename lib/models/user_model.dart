import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:algolia/algolia.dart';

class UserModel {
  String imgUrl;
  String? email;
  DateTime? modified;
  DateTime? created;
  String? uid;
  String username;
  int? critiqueCount;
  String? fcmToken;
  // int? watchListCount;

  UserModel({
    required this.imgUrl,
    required this.email,
    required this.modified,
    required this.created,
    required this.uid,
    required this.username,
    required this.critiqueCount,
    this.fcmToken,
    // required this.watchListCount,
  });

  factory UserModel.fromDoc({required DocumentSnapshot data}) {
    return UserModel(
      imgUrl: data['imgUrl'],
      email: data['email'],
      created: data['created'].toDate(),
      modified: data['modified'].toDate(),
      uid: data['uid'],
      username: data['username'],
      critiqueCount: data['critiqueCount'],
      fcmToken: data['fcmToken'],
      // watchListCount: data['watchListCount'],
    );
  }

  factory UserModel.fromAlgolia(AlgoliaObjectSnapshot aob) {
    Map<String, dynamic> data = aob.data;
    return UserModel(
      imgUrl: data['imgUrl'],
      email: data['email'],
      // created: data['created'].toDate(),//todo:
      // modified: data['modified'].toDate(),//todo:
      created: DateTime.now(),
      modified: DateTime.now(),
      uid: data['uid'],
      username: data['username'],
      critiqueCount: data['critiqueCount'],
      fcmToken: data['fcmToken'],
      // watchListCount: data['watchListCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': imgUrl,
      'email': email,
      'created': created,
      'modified': modified,
      'uid': uid,
      'username': username,
      'critiqueCount': critiqueCount,
      'fcmToken': fcmToken,
      // 'watchListCount': watchListCount,
    };
  }
}
