// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SuggestionModel _$$_SuggestionModelFromJson(Map<String, dynamic> json) =>
    _$_SuggestionModel(
      id: json['id'] as String?,
      message: json['message'] as String,
      uid: json['uid'] as String,
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$$_SuggestionModelToJson(_$_SuggestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'uid': instance.uid,
      'created': instance.created.toIso8601String(),
    };
