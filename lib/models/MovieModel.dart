import 'package:flutter/material.dart';

class MovieModel {
  final String imdbID;
  final String title;
  final String poster;

  MovieModel({
    @required this.imdbID,
    @required this.title,
    @required this.poster,
  });

  factory MovieModel.fromJSON({@required Map map}) {
    return MovieModel(
      imdbID: map['imdbID'],
      title: map['title'],
      poster: map['poster'],
    );
  }
}
