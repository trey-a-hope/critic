import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentModel {
  String id;
  String message;
  String uid;
  DateTime created;

  CommentModel({
    @required this.id,
    @required this.message,
    @required this.uid,
    @required this.created,
  });

  factory CommentModel.fromDoc({@required DocumentSnapshot ds}) {
    final Map<String, dynamic> data = ds.data();
    return CommentModel(
      id: data['id'],
      message: data['message'],
      uid: data['uid'],
      created: data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'uid': uid,
      'created': created,
    };
  }
}
