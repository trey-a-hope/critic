import 'dart:async';

import 'package:critic/blocs/searchMovies/SearchMoviesCache.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesClient.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesResultItem.dart';

import 'SearchMoviesResult.dart';

class SearchMoviesRepository {
  final SearchMoviesCache cache;
  final SearchMoviesClient client;

  SearchMoviesRepository(this.cache, this.client);

  Future<SearchMoviesResult> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      final result = await client.search(term);
      cache.set(term, result);
      return result;
    }
  }
}
