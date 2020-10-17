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

  LoadedState({
    @required this.currentUser,
    @required this.critiqueUser,
    @required this.critiqueModel,
    @required this.movieModel,
    @required this.isLiked,
  });

  @override
  List<Object> get props => [
        currentUser,
        critiqueUser,
        critiqueModel,
        movieModel,
        isLiked,
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
