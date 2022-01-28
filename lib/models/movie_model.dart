import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel {
  DateTime? addedToWatchList = DateTime.now();

  MovieModel({
    required this.imdbID,
    required this.title,
    required this.poster,
    required this.released,
    required this.plot,
    required this.director,
    required this.imdbRating,
    required this.imdbVotes,
    required this.genre,
    required this.actors,
    this.addedToWatchList,
  });

  factory MovieModel.fromJSON({required Map map}) {
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

  factory MovieModel.fromDoc({required DocumentSnapshot data}) {
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

  /// The id of the movie in the omdb.
  final String imdbID;

  /// Title of the movie.
  final String title;

  /// Image url of the poster.
  final String poster;

  /// Date the movie was released.
  final String released;

  /// Plot/description of movie.
  final String plot;

  /// The director.
  final String director;

  ///Rating on imdb.
  final String imdbRating;

  /// Number of votes on imdb.
  final String imdbVotes;

  /// Movie genre.
  final String genre;

  /// Actors in the movie.
  final String actors;
}
