import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:algolia/algolia.dart';

class UserModel {
  UserModel({
    required this.imgUrl,
    required this.email,
    required this.modified,
    required this.created,
    required this.uid,
    required this.username,
    required this.critiqueCount,
    this.fcmToken,
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
    );
  }

  factory UserModel.fromAlgolia(AlgoliaObjectSnapshot aob) {
    Map<String, dynamic> data = aob.data;
    return UserModel(
      imgUrl: data['imgUrl'],
      email: data['email'],
      created: DateTime.fromMillisecondsSinceEpoch(
        data['created'],
      ),
      modified: DateTime.fromMillisecondsSinceEpoch(
        data['modified'],
      ),
      uid: data['uid'],
      username: data['username'],
      critiqueCount: data['critiqueCount'],
      fcmToken: data['fcmToken'],
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
    };
  }

  /// The unique id of the user.
  String? uid;

  /// The users email.
  String? email;

  /// User's image url.
  String imgUrl;

  /// Firebase Cloud Message token for push notifications.
  String? fcmToken;

  /// Time the user was last modified.
  DateTime modified;

  /// Time the user was created.
  DateTime created;

  /// Username of the user.
  String username;

  /// Number of critiques.
  int critiqueCount;
}
