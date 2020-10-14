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

  factory CritiqueModel.fromJSON({@required Map map}) {
    return CritiqueModel(
      imdbID: map['imdbID'],
      id: map['id'],
      uid: map['uid'],
      message: map['message'],
      safe: map['safe'],
      modified: map['modified'],
      created: map['created'],
      movieTitle: map['movieTitle'],
      moviePoster: map['moviePoster'],
      movieYear: map['movieYear'],
      moviePlot: map['moviePlot'],
      movieDirector: map['movieDirector'],
      imdbRating: map['imdbRating'],
      imdbVotes: map['imdbVotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actor': uid,
      'message': message,
      'uid': uid,
      'movieTitle': movieTitle,
      'moviePoster': moviePoster,
      'movieYear': movieYear,
      'moviePlot': moviePlot,
      'movieDirector': movieDirector,
      'imdbID': imdbID,
      'imdbRating': imdbRating,
      'imdbVotes': imdbVotes,
    };
  }
}