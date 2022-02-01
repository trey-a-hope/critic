// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MovieModel _$$_MovieModelFromJson(Map<String, dynamic> json) =>
    _$_MovieModel(
      imdbID: json['imdbID'] as String,
      title: json['Title'] as String,
      poster: json['Poster'] as String,
      released: json['Released'] as String,
      plot: json['Plot'] as String,
      director: json['Director'] as String,
      writer: json['Writer'] as String,
      runtime: json['Runtime'] as String,
      imdbRating: json['imdbRating'] as String,
      imdbVotes: json['imdbVotes'] as String,
      genre: json['Genre'] as String,
      actors: json['Actors'] as String,
      rated: json['Rated'] as String,
      year: json['Year'] as String,
    );

Map<String, dynamic> _$$_MovieModelToJson(_$_MovieModel instance) =>
    <String, dynamic>{
      'imdbID': instance.imdbID,
      'Title': instance.title,
      'Poster': instance.poster,
      'Released': instance.released,
      'Plot': instance.plot,
      'Director': instance.director,
      'Writer': instance.writer,
      'Runtime': instance.runtime,
      'imdbRating': instance.imdbRating,
      'imdbVotes': instance.imdbVotes,
      'Genre': instance.genre,
      'Actors': instance.actors,
      'Rated': instance.rated,
      'Year': instance.year,
    };
