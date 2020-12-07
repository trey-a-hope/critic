import 'package:critic/models/MovieModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WatchlistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends WatchlistEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class WatchlistUpdatedEvent extends WatchlistEvent {
  final List<MovieModel> movies;

  WatchlistUpdatedEvent({
    @required this.movies,
  });

  @override
  List<Object> get props => [
        movies,
      ];
}
