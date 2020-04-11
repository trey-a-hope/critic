import 'package:flutter/material.dart';

class SearchQueryModel {
  final String imdbID;
  final String title;
  final String poster;
  final String type;
  final String year;

  SearchQueryModel(
      {@required this.imdbID,
      @required this.title,
      @required this.poster,
      @required this.type,
      @required this.year});

  factory SearchQueryModel.fromJSON({@required Map map}) {
    return SearchQueryModel(
        imdbID: map['imdbID'],
        title: map['Title'],
        poster: map['Poster'],
        type: map['Type'],
        year: map['Year']);
  }
}
