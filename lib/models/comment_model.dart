import 'package:critic/models/user_Model.dart';
import 'package:flutter/material.dart';

class CommentModel {
  String uid;
  String comment;
  List<String> likes;
  DateTime created;

  UserModel user; //Used for the FE only.

  CommentModel({
    @required this.uid,
    @required this.comment,
    @required this.likes,
    this.created,
  });

  factory CommentModel.fromJSON({@required Map map}) {
    return CommentModel(
      uid: map['uid'],
      comment: map['comment'],
      created: DateTime.parse(map['created']),
      likes: List.from(map['likes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'comment': comment,
      'likes': [],
    };
  }
}
