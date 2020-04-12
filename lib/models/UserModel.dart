import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String id;
  String imgUrl;
  String email;
  DateTime modified;
  DateTime created;
  String uid;
  String username;

  UserModel(
      {@required this.id,
      @required this.imgUrl,
      @required this.email,
      @required this.modified,
      @required this.created,
      @required this.uid,
      @required this.username});

  static UserModel extractDocument(
      {@required DocumentSnapshot documentSnapshot}) {
    return UserModel(
      id: documentSnapshot.data['id'],
      imgUrl: documentSnapshot.data['imgUrl'],
      email: documentSnapshot.data['email'],
      created: documentSnapshot.data['created'].toDate(),
      modified: documentSnapshot.data['modified'].toDate(),
      uid: documentSnapshot.data['uid'],
      username: documentSnapshot.data['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'email': email,
      'modified': modified,
      'created': created,
      'uid': uid,
      'username': username
    };
  }
}
