import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';

class UserModel {
  String imgUrl;
  String email;
  DateTime modified;
  DateTime created;
  String uid;
  String username;
  int critiqueCount;

  UserModel({
    @required this.imgUrl,
    @required this.email,
    @required this.modified,
    @required this.created,
    @required this.uid,
    @required this.username,
    @required this.critiqueCount,
  });

  static UserModel extractDocument({@required DocumentSnapshot ds}) {
    final Map<String, dynamic> data = ds.data();
    return UserModel(
      imgUrl: data['imgUrl'],
      email: data['email'],
      created: data['created'].toDate(),
      modified: data['modified'].toDate(),
      uid: data['uid'],
      username: data['username'],
      critiqueCount: data['critiqueCount'],
    );
  }

  static UserModel extractAlgoliaObjectSnapshot(AlgoliaObjectSnapshot aob) {
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': imgUrl,
      'email': email,
      'modified': modified,
      'created': created,
      'uid': uid,
      'username': username
    };
  }
}
