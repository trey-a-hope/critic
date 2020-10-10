import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EditProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends EditProfileState {}

class EditProfileStartState extends EditProfileState {
  final UserModel currentUser;

  EditProfileStartState({
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        currentUser,
      ];
}

class ErrorState extends EditProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
