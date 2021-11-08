part of 'watch_list_bloc.dart';

class WatchlistState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends WatchlistState {}

class LoadingState extends WatchlistState {}

class LoadedState extends WatchlistState {
  final List<MovieModel> movies;
  LoadedState({
    required this.movies,
  });

  @override
  List<Object> get props => [
        movies,
      ];
}

class EmptyWatchlistState extends WatchlistState {}
