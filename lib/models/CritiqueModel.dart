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
}
