// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_movies_result_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SearchMoviesResultItemModel _$$_SearchMoviesResultItemModelFromJson(
        Map<String, dynamic> json) =>
    _$_SearchMoviesResultItemModel(
      imdbID: json['imdbID'] as String,
      title: json['Title'] as String,
      poster: json['Poster'] as String,
      type: json['Type'] as String,
      year: json['Year'] as String,
    );

Map<String, dynamic> _$$_SearchMoviesResultItemModelToJson(
        _$_SearchMoviesResultItemModel instance) =>
    <String, dynamic>{
      'imdbID': instance.imdbID,
      'Title': instance.title,
      'Poster': instance.poster,
      'Type': instance.type,
      'Year': instance.year,
    };
