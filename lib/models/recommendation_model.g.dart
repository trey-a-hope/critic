// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RecommendationModel _$$_RecommendationModelFromJson(
        Map<String, dynamic> json) =>
    _$_RecommendationModel(
      id: json['id'] as String,
      message: json['message'] as String,
      imdbID: json['imdbID'] as String,
      uid: json['uid'] as String,
      created:
          const TimestampConverter().fromJson(json['created'] as Timestamp),
    );

Map<String, dynamic> _$$_RecommendationModelToJson(
        _$_RecommendationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'imdbID': instance.imdbID,
      'uid': instance.uid,
      'created': const TimestampConverter().toJson(instance.created),
    };
