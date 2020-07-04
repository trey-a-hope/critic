import 'package:flutter/material.dart';

class SearchMoviesResultItem {
  final String imdbID;
  final String title;
  final String poster;
  final String type;
  final String year;

  const SearchMoviesResultItem({
    @required this.imdbID,
    @required this.title,
    @required this.poster,
    @required this.type,
    @required this.year,
  });

  static SearchMoviesResultItem fromJson(dynamic json) {
    return SearchMoviesResultItem(
      imdbID: json['imdbID'] as String,
      title: json['Title'] as String,
      poster: json['Poster'] as String,
      type: json['Type'] as String,
      year: json['Year'] as String,
    );
  }
}
