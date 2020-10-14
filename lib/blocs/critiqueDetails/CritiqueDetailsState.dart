import 'package:critic/models/CritiqueModel.dart';
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
  final CritiqueModel critiqueModel;

  LoadedState({
    @required this.currentUser,
    @required this.critiqueModel,
  });

  @override
  List<Object> get props => [
        currentUser,
        critiqueModel,
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
