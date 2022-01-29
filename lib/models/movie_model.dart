import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_model.freezed.dart';

part 'movie_model.g.dart';

@freezed
class MovieModel with _$MovieModel {
  factory MovieModel({
    /// The id of the movie in the omdb.
    required String imdbID,

    /// Title of the movie.
    @JsonKey(name: 'Title') required String title,

    /// Image url of the poster.
    @JsonKey(name: 'Property') required String poster,

    /// Date the movie was released.
    @JsonKey(name: 'Released') required String released,

    /// Plot/description of movie.
    @JsonKey(name: 'Plot') required String plot,

    /// The director.
    @JsonKey(name: 'Director') required String director,

    /// Rating on imdb.
    required String imdbRating,

    /// Number of votes on imdb.
    required String imdbVotes,

    /// Movie genre.
    @JsonKey(name: 'Genre') required String genre,

    /// Actors in the movie.
    @JsonKey(name: 'Actors') required String actors,

    /// Parental rating for movie.
    @JsonKey(name: 'Rated') required String rated,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}
