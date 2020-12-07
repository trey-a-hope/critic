import 'package:flutter/material.dart';

class MovieModel {
  final String imdbID;
  final String title;
  final String poster;
  final String released;
  final String plot;
  final String director;
  final String imdbRating;
  final String imdbVotes;
  final String genre;
  final String actors;

  MovieModel({
    @required this.imdbID,
    @required this.title,
    @required this.poster,
    @required this.released,
    @required this.plot,
    @required this.director,
    @required this.imdbRating,
    @required this.imdbVotes,
    @required this.genre,
    @required this.actors,
  });

  factory MovieModel.fromJSON({@required Map map}) {
    return MovieModel(
      imdbID: map['imdbID'],
      title: map['Title'],
      poster: map['Poster'],
      released: map['Released'],
      plot: map['Plot'],
      director: map['Director'],
      imdbRating: map['imdbRating'],
      imdbVotes: map['imdbVotes'],
      genre: map['Genre'],
      actors: map['Actors'],
    );
  }
}
