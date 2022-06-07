// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RecipeModel _$$_RecipeModelFromJson(Map<String, dynamic> json) =>
    _$_RecipeModel(
      id: json['id'] as String,
      foodItem: json['foodItem'] as String,
      image: json['image'],
      title: json['title'] as String,
      instructions: json['instructionsFormatted'] as String,
    );

Map<String, dynamic> _$$_RecipeModelToJson(_$_RecipeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'foodItem': instance.foodItem,
      'image': instance.image,
      'title': instance.title,
      'instructionsFormatted': instance.instructions,
    };
