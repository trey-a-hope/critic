import 'package:critic/models/MovieModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateCritiqueState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends CreateCritiqueState {}

class CreateCritiqueStartState extends CreateCritiqueState {
  final MovieModel movie;
  CreateCritiqueStartState({
    @required this.movie,
  });

  @override
  List<Object> get props => [
        movie,
      ];
}
