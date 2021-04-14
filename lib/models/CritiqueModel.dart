import 'package:critic/models/CommentModel.dart';
import 'package:flutter/material.dart';
import 'MovieModel.dart';

class CritiqueModel {
  String id;
  String message;
  String imdbID;
  String uid;
  List<CommentModel> comments;
  DateTime created;
  DateTime modified;
  double rating;
  List<String> likes;
  List<String> genres;

  MovieModel movie; //Used on FE only.

  CritiqueModel({
    @required this.id,
    @required this.message,
    @required this.imdbID,
    @required this.uid,
    @required this.comments,
    @required this.created,
    @required this.modified,
    @required this.rating,
    @required this.likes,
    @required this.genres,
  });

  factory CritiqueModel.fromJSON({@required Map map}) {
    return CritiqueModel(
      id: map['_id'],
      message: map['message'],
      imdbID: map['imdbID'],
      uid: map['uid'],
      comments: List.from((map['comments'] as List<dynamic>).map((element) {
        return CommentModel.fromJSON(map: element);
      }).toList()),
      created: DateTime.parse(map['created']),
      modified: DateTime.parse(map['modified']),
      rating: map['rating'].toDouble(),
      likes: List.from(map['likes']),
      genres: List.from(map['genres']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'imdbID': imdbID,
      'uid': uid,
      //'comments': [], //todo:
      'rating': rating,
      //'likes': [], //todo:
      'genres': genres,
      'created': created.toIso8601String(),
      'modified': modified.toIso8601String(),
    };
  }
}
