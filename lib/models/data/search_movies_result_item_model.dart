import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_movies_result_item_model.freezed.dart';
part 'search_movies_result_item_model.g.dart';

@freezed
class SearchMoviesResultItemModel with _$SearchMoviesResultItemModel {
  factory SearchMoviesResultItemModel({
    /// Id of the movie.
    required String imdbID,

    /// Title of movie.
    @JsonKey(name: 'Title') required String title,

    /// Image url of the poster.
    @JsonKey(name: 'Poster') required String poster,

    /// Type of movie.
    @JsonKey(name: 'Type') required String type,

    /// Year the movie was released.
    @JsonKey(name: 'Year') required String year,
  }) = _SearchMoviesResultItemModel;

  factory SearchMoviesResultItemModel.fromJson(Map<String, dynamic> json) =>
      _$SearchMoviesResultItemModelFromJson(json);
}
