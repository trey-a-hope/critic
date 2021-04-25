part of 'search_movies_bloc.dart';

abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();

  @override
  List<Object> get props => [];
}

class SearchMoviesStateEmpty extends SearchMoviesState {}

class SearchMoviesStateLoading extends SearchMoviesState {}

class SearchMoviesStateSuccess extends SearchMoviesState {
  final List<SearchMoviesResultItemModel> movies;

  const SearchMoviesStateSuccess({
    @required this.movies,
  });

  @override
  List<Object> get props => [movies];

  @override
  String toString() => 'SearchStateSuccess { items: ${movies.length} }';
}

class SearchMoviesStateError extends SearchMoviesState {
  final dynamic error;

  const SearchMoviesStateError({
    @required this.error,
  });

  @override
  List<Object> get props => [error];
}
