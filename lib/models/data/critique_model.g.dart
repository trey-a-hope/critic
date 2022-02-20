// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'critique_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CritiqueModel _$$_CritiqueModelFromJson(Map<String, dynamic> json) =>
    _$_CritiqueModel(
      id: json['id'] as String?,
      message: json['message'] as String,
      imdbID: json['imdbID'] as String,
      uid: json['uid'] as String,
      created: DateTime.parse(json['created'] as String),
      modified: DateTime.parse(json['modified'] as String),
      rating: (json['rating'] as num).toDouble(),
      likes: (json['likes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_CritiqueModelToJson(_$_CritiqueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'imdbID': instance.imdbID,
      'uid': instance.uid,
      'created': instance.created.toIso8601String(),
      'modified': instance.modified.toIso8601String(),
      'rating': instance.rating,
      'likes': instance.likes,
    };
