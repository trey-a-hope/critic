part of 'search_movies_bloc.dart';

class SearchMoviesRepository {
  final SearchMoviesCache cache;

  SearchMoviesRepository({required this.cache});

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
