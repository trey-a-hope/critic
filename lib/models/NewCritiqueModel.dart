import 'package:critic/models/NewCommentModel.dart';
import 'package:flutter/material.dart';

class NewCritiqueModel {
  String id;
  String message;
  String imdbID;
  String uid;
  List<NewCommentModel> comments;
  DateTime created;
  int rating;
  List<String> likes;

  NewCritiqueModel({
    @required this.id,
    @required this.message,
    @required this.imdbID,
    @required this.uid,
    @required this.comments,
    @required this.created,
    @required this.rating,
    @required this.likes,
  });

  factory NewCritiqueModel.fromJSON({@required Map map}) {
    return NewCritiqueModel(
      id: map['_id'],
      message: map['message'],
      imdbID: map['imdbID'],
      uid: map['uid'],
      comments: List.from((map['comments'] as List<dynamic>).map((element) {
        return NewCommentModel.fromJSON(map: element);
      }).toList()),
      created: DateTime.parse(map['created']),
      rating: map['rating'],
      likes: List.from(map['likes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      'imdbID': imdbID,
      'uid': uid,
      'comments': comments,
      'created': created,
      'rating': rating,
      'likes': likes,
    };
  }
}
