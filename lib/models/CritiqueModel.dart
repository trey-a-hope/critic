import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CritiqueModel {
  String imdbID;
  String id;
  String userID;
  String message;
  DateTime modified;
  DateTime created;

  CritiqueModel(
      {@required this.imdbID,
      @required this.id,
      @required this.userID,
      @required this.message,
      @required this.modified,
      @required this.created});

  static CritiqueModel extractDocument({@required DocumentSnapshot ds}) {
    return CritiqueModel(
      imdbID: ds.data['imdbID'],
      id: ds.data['id'],
      userID: ds.data['userID'],
      message: ds.data['message'],
      modified: ds.data['modified'].toDate(),
      created: ds.data['created'].toDate(),
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
    };
  }
}
