import 'package:freezed_annotation/freezed_annotation.dart';

part 'critique_model.freezed.dart';

part 'critique_model.g.dart';

@freezed
class CritiqueModel with _$CritiqueModel {
  factory CritiqueModel({
    /// Id of the critique
    String? id,

    /// The review of the movie
    required String message,

    /// Movie Id
    required String imdbID,

    /// User Id associated with this critique
    required String uid,

    /// Comments
    // required List<CommentModel> comments,TODO: Uncomment this after new UI of critique details page.

    /// Time this was posted
    required DateTime created,

    /// Time this was modified
    required DateTime modified,

    /// Rating of movie
    required double rating,

    /// Users who liked the critique
    required List<String> likes,
  }) = _CritiqueModel;

  factory CritiqueModel.fromJson(Map<String, dynamic> json) =>
      _$CritiqueModelFromJson(json);
}
