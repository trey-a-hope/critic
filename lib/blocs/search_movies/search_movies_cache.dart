part of 'search_movies_bloc.dart';

class SearchMoviesCache {
  final _cache = <String, SearchMoviesResult>{};

  SearchMoviesResult get(String term) => _cache[term];

  void set(String term, SearchMoviesResult result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);
}
