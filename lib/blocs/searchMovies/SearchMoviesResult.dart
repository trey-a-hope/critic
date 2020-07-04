import 'package:critic/blocs/searchMovies/SearchMoviesResultItem.dart';
import 'package:flutter/material.dart';

class SearchMoviesResult {
  final List<SearchMoviesResultItem> items;

  const SearchMoviesResult({@required this.items});

  static SearchMoviesResult fromJson(Map<String, dynamic> json) {
    final items = (json['Search'] as List<dynamic>)
        .map((dynamic item) =>
            SearchMoviesResultItem.fromJson(item as Map<String, dynamic>))
        .toList();
    return SearchMoviesResult(items: items);
  }
}
