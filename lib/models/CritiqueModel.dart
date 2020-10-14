import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CritiqueModel {
  String id;
  String imdbID;
  String uid;
  String message;
  bool safe;
  DateTime modified;
  DateTime created;
  String movieTitle;
  String moviePoster;
  String movieYear;
  String moviePlot;
  String movieDirector;
  String imdbRating;
  String imdbVotes;

  CritiqueModel({
    @required this.imdbID,
    @required this.id,
    @required this.uid,
    @required this.message,
    @required this.safe,
    @required this.modified,
    @required this.created,
    @required this.movieTitle,
    @required this.moviePoster,
    @required this.movieYear,
    @required this.moviePlot,
    @required this.movieDirector,
    @required this.imdbRating,
    @required this.imdbVotes,
  });

  // static CritiqueModel extractDocument({@required DocumentSnapshot ds}) {
  //   final Map<String, dynamic> data = ds.data();

  //   return CritiqueModel(
  //     imdbID: data['imdbID'] as String,
  //     id: data['id'] as String,
  //     uid: data['uid'] as String,
  //     message: data['message'] as String,
  //     safe: data['safe'] as bool,
  //     modified: data['modified'].toDate(),
  //     created: data['created'].toDate(),
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imdbID': imdbID,
      'uid': uid,
      'message': message,
      'modified': modified,
      'created': created,
      'safe': safe,
      'movieTitle': movieTitle,
      'moviePoster': moviePoster,
      'movieYear': movieYear,
      'moviePlot': moviePlot,
      'movieDirector': movieDirector,
      'imdbRating': imdbRating,
      'imdbVotes': imdbVotes,
    };
  }
}
