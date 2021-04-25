import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestionModel {
  String id;
  String uid;
  String message;
  DateTime created;

  SuggestionModel({
    @required this.id,
    @required this.uid,
    @required this.message,
    @required this.created,
  });

  factory SuggestionModel.fromDoc({@required DocumentSnapshot ds}) {
    final Map<String, dynamic> data = ds.data();
    return SuggestionModel(
      id: data['id'],
      uid: data['uid'],
      message: data['message'],
      created: data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'message': message,
      'created': created,
    };
  }
}
