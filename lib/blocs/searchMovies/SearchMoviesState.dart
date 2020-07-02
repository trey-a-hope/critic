//import 'package:bloc/bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SearchMoviesState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends SearchMoviesState {}

class LoadedState extends SearchMoviesState {
  final UserModel currentUser;

  LoadedState({
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        currentUser,
      ];
}

class ErrorState extends SearchMoviesState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
