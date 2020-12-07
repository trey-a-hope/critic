import 'package:critic/models/MovieModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class WatchlistState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends WatchlistState {}

class LoadedState extends WatchlistState {
  final List<MovieModel> movies;
  LoadedState({
    @required this.movies,
  });

  @override
  List<Object> get props => [
        movies,
      ];
}

class EmptyWatchlistState extends WatchlistState {}
