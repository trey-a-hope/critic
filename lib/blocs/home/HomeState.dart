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

class NoCritiquesState extends HomeState {
  NoCritiquesState();

  @override
  List<Object> get props => [];
}

class FoundCritiquesState extends HomeState {
  final List<CritiqueModel> critiques;
  final UserModel currentUser;

  FoundCritiquesState({
    @required this.critiques,
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        critiques,
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
