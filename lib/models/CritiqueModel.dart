import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CritiqueModel {
  String id;
  String imdbID;
  String uid;
  String message;
  DateTime modified;
  DateTime created;
  String movieTitle;
  String moviePoster;
  String movieYear;
  String moviePlot;
  String movieDirector;
  String imdbRating;
  String imdbVotes;
  int likeCount;

  CritiqueModel({
    @required this.imdbID,
    @required this.id,
    @required this.uid,
    @required this.message,
    @required this.modified,
    @required this.created,
    @required this.movieTitle,
    @required this.moviePoster,
    @required this.movieYear,
    @required this.moviePlot,
    @required this.movieDirector,
    @required this.imdbRating,
    @required this.imdbVotes,
    @required this.likeCount,
  });

  factory CritiqueModel.fromJSON({@required Map map}) {
    return CritiqueModel(
      imdbID: map['imdbID'],
      id: map['id'],
      uid: map['uid'],
      message: map['message'],
      modified: map['modified'],
      created: DateTime.parse(map['time']).subtract(
        Duration(hours: 5),
      ), //time is 4 hours fast, I might have selected the wrong region for Stream.
      movieTitle: map['movieTitle'],
      moviePoster: map['moviePoster'],
      movieYear: map['movieYear'],
      moviePlot: map['moviePlot'],
      movieDirector: map['movieDirector'],
      imdbRating: map['imdbRating'],
      imdbVotes: map['imdbVotes'],
      likeCount: 0, //todo: this should be updated on the activity as well.
    );
  }

  factory CritiqueModel.fromDoc({@required DocumentSnapshot ds}) {
    final Map<String, dynamic> data = ds.data();
    return CritiqueModel(
      imdbID: data['imdbID'],
      id: data['id'],
      uid: data['uid'],
      message: data['message'],
      modified: data['modified'],
      movieTitle: data['movieTitle'],
      moviePoster: data['moviePoster'],
      movieYear: data['movieYear'],
      moviePlot: data['moviePlot'],
      movieDirector: data['movieDirector'],
      imdbRating: data['imdbRating'],
      imdbVotes: data['imdbVotes'],
      created: data['created'].toDate(),
      likeCount: data['likeCount'],
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
