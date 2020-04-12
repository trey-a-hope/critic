import 'package:flutter/material.dart';

class MovieModel {
  final String imdbID;
  final String title;
  final String poster;
  final String year;
  final String plot;
  final String director;
  final String imdbRating;
  final String imdbVotes;

  MovieModel(
      {@required this.imdbID,
      @required this.title,
      @required this.poster,
      @required this.year,
      @required this.plot,
      @required this.director,
      @required this.imdbRating,
      @required this.imdbVotes});

  factory MovieModel.fromJSON({@required Map map}) {
    return MovieModel(
        imdbID: map['imdbID'],
        title: map['Title'],
        poster: map['Poster'],
        year: map['Year'],
        plot: map['Plot'],
        director: map['Director'],
        imdbRating: map['imdbRating'],
        imdbVotes: map['imdbVotes']);
  }
}
