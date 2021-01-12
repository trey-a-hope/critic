import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateCritiqueState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends CreateCritiqueState {}

class LoadedState extends CreateCritiqueState {
  final MovieModel movie;
  final bool watchListHasMovie;
  final UserModel currentUser;

  LoadedState({
    @required this.movie,
    @required this.watchListHasMovie,
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        movie,
        watchListHasMovie,
        currentUser,
      ];
}
