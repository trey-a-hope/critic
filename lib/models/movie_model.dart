class MovieModel {
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
    required this.rated,
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
      rated: map['Rated'],
    );
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

  /// Rating on imdb.
  final String imdbRating;

  /// Number of votes on imdb.
  final String imdbVotes;

  /// Movie genre.
  final String genre;

  /// Actors in the movie.
  final String actors;

  /// Parental rating for movie.
  final String rated;
}
