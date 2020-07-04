import 'dart:async';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesCache.dart';
import 'package:critic/services/MovieService.dart';
import 'package:flutter/material.dart';

import 'SearchMoviesResult.dart';

class SearchMoviesRepository {
  final SearchMoviesCache cache;

  SearchMoviesRepository({@required this.cache});

  Future<SearchMoviesResult> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      final result = await locator<MovieService>().search(term: term);
      cache.set(term, result);
      return result;
    }
  }
}
