import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:critic/converters/timestamp_converter.dart';

part 'recommendation_model.freezed.dart';

part 'recommendation_model.g.dart';

@freezed
class RecommendationModel with _$RecommendationModel {
  factory RecommendationModel({
    /// The unique id of the recommendation.
    required String id,

    /// The message.
    required String message,

    /// Movie id associated with the recommendation.
    required String imdbID,

    /// User id of the person who sent the recommendation.
    required String uid,

    /// Date it was created.
    @TimestampConverter() required DateTime created,
  }) = _RecommendationModel;

  factory RecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationModelFromJson(json);
}
