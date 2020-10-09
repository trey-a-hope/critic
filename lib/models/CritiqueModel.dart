import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CritiqueModel {
  String imdbID;
  String id;
  String userID;
  String message;
  bool safe;
  DateTime modified;
  DateTime created;

  CritiqueModel(
      {@required this.imdbID,
      @required this.id,
      @required this.userID,
      @required this.message,
      @required this.safe,
      @required this.modified,
      @required this.created});

  static CritiqueModel extractDocument({@required DocumentSnapshot ds}) {
    final Map<String, dynamic> data = ds.data();

    return CritiqueModel(
      imdbID: data['imdbID'] as String,
      id: data['id'] as String,
      userID: data['userID'] as String,
      message: data['message'] as String,
      safe: data['safe'] as bool,
      modified: data['modified'].toDate(),
      created: data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imdbID': imdbID,
      'userID': userID,
      'message': message,
      'modified': modified,
      'created': created,
      'safe': safe,
    };
  }
}
