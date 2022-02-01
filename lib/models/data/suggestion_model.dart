import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggestion_model.freezed.dart';
part 'suggestion_model.g.dart';

@freezed
class SuggestionModel with _$SuggestionModel {
  factory SuggestionModel({
    /// The unique id of the suggestion.
    String? id,

    /// The message.
    required String message,

    /// User id of the person who sent the suggestion.
    required String uid,

    /// Date it was created.
    required DateTime created,
  }) = _SuggestionModel;

  factory SuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SuggestionModelFromJson(json);
}
