import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';

part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  factory CommentModel({
    /// Id of the user who posted comment.
    required String uid,

    /// Text of the comment.
    required String comment,

    /// Users who liked the comment.
    required List<String> likes,

    /// Time this was posted
    required DateTime created,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
