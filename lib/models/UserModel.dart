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

  UserModel(
      {
      @required this.imgUrl,
      @required this.email,
      @required this.modified,
      @required this.created,
      @required this.uid,
      @required this.username});

  static UserModel extractDocument(
      {@required DocumentSnapshot ds}) {
    return UserModel(
      imgUrl: ds.data['imgUrl'],
      email: ds.data['email'],
      created: ds.data['created'].toDate(),
      modified: ds.data['modified'].toDate(),
      uid: ds.data['uid'],
      username: ds.data['username'],
    );
  }

  static UserModel extractAlgoliaObjectSnapshot(AlgoliaObjectSnapshot aob) {
  Map<String, dynamic> data = aob.data;
    return UserModel(
      imgUrl: data['imgUrl'],
      email: data['email'],
      // created: data['created'].toDate(),
      // modified: data['modified'].toDate(),
      created: DateTime.now(),
      modified: DateTime.now(),
      uid: data['uid'],
      username: data['username'],
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
