import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  DateTime addedToWatchList = DateTime.now();

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
    this.addedToWatchList,
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

  factory MovieModel.fromDoc({@required DocumentSnapshot ds}) {
    final Map<String, dynamic> data = ds.data();

    return MovieModel(
      imdbID: data['imdbID'],
      title: data['title'],
      poster: data['poster'],
      released: data['released'],
      plot: data['plot'],
      director: data['director'],
      imdbRating: data['imdbRating'],
      imdbVotes: data['imdbVotes'],
      genre: data['genre'],
      actors: data['actors'],
      addedToWatchList: data['addedToWatchList'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imdbID': imdbID,
      'title': title,
      'poster': poster,
      'released': released,
      'plot': plot,
      'director': director,
      'imdbRating': imdbRating,
      'imdbVotes': imdbVotes,
      'genre': genre,
      'actors': actors,
      'addedToWatchList': addedToWatchList,
    };
  }
}
