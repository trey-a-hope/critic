import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CritiqueDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends CritiqueDetailsState {}

class LoadedState extends CritiqueDetailsState {
  final UserModel currentUser;
  final UserModel critiqueUser;
  final CritiqueModel critiqueModel;
  final MovieModel movieModel;
  final bool isLiked;
  final int likeCount;

  LoadedState({
    @required this.currentUser,
    @required this.critiqueUser,
    @required this.critiqueModel,
    @required this.movieModel,
    @required this.isLiked,
    @required this.likeCount,
  });

  @override
  List<Object> get props => [
        currentUser,
        critiqueUser,
        critiqueModel,
        movieModel,
        isLiked,
        likeCount,
      ];
}

class ErrorState extends CritiqueDetailsState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
