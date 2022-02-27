import 'package:critic/services/movie_service.dart';
import 'package:critic/ui/search_movies/search_movies_cache.dart';
import 'package:critic/ui/search_movies/search_movies_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchMoviesRepository {
  final SearchMoviesCache cache;

  final MovieService _movieService = Get.find();

  SearchMoviesRepository({required this.cache});

  Future<SearchMoviesResult> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      try {
        final result = await _movieService.search(term: term);
        cache.set(term, result);
        return result;
      } catch (e) {
        debugPrint(e.toString());
        throw Exception(e);
      }
    }
  }
}
