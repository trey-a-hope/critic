//import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends ProfileState {}

class LoadedState extends ProfileState {
  final UserModel currentUser;
  final int followersCount;
  final int followingsCount;
  final int critiquesCount;
  final List<CritiqueModel> critiques;

  LoadedState(
      {@required this.currentUser,
      @required this.followersCount,
      @required this.followingsCount,
      @required this.critiquesCount,
      @required this.critiques});

  @override
  List<Object> get props => [
        currentUser,
        followersCount,
        followingsCount,
        critiquesCount,
        critiques,
      ];
}

class ErrorState extends ProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
