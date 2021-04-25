part of 'search_movies_bloc.dart';

class SearchMoviesResult {
  final List<SearchMoviesResultItemModel> items;

  const SearchMoviesResult({@required this.items});

  static SearchMoviesResult fromJson(Map<String, dynamic> json) {
    final items = (json['Search'] as List<dynamic>)
        .map((dynamic item) =>
            SearchMoviesResultItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return SearchMoviesResult(items: items);
  }
}
