//import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends HomeState {}

// class NoCritiquesState extends HomeState {
//   NoCritiquesState();

//   @override
//   List<Object> get props => [];
// }

class LoadedState extends HomeState {
  final UserModel currentUser;

  LoadedState({
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        currentUser,
      ];
}

class ErrorState extends HomeState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
