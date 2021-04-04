import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewCommentModel {
  String uid;
  String comment;
  List<String> likes;
  DateTime created;

  NewCommentModel({
    @required this.uid,
    @required this.comment,
    @required this.likes,
    @required this.created,
  });

  factory NewCommentModel.fromJSON({@required Map map}) {
    return NewCommentModel(
      uid: map['uid'],
      comment: map['comment'],
      created: DateTime.parse(map['created']),
      likes: List.from(map['likes']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     '_id': id,
  //     'message': message,
  //     'imdbID': imdbID,
  //     'uid': uid,
  //     'comments': comments,
  //     'created': created,
  //     'rating': rating,
  //     'likes': likes,
  //   };
  // }
}
