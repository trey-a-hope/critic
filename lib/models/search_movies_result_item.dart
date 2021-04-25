import 'package:flutter/material.dart';

class SearchMoviesResultItemModel {
  final String imdbID;
  final String title;
  final String poster;
  final String type;
  final String year;

  const SearchMoviesResultItemModel({
    @required this.imdbID,
    @required this.title,
    @required this.poster,
    @required this.type,
    @required this.year,
  });

  static SearchMoviesResultItemModel fromJson(dynamic json) {
    return SearchMoviesResultItemModel(
      imdbID: json['imdbID'] as String,
      title: json['Title'] as String,
      poster: json['Poster'] as String,
      type: json['Type'] as String,
      year: json['Year'] as String,
    );
  }
}
