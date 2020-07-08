//import 'package:bloc/bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OtherProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends OtherProfileState {}

class LoadedState extends OtherProfileState {
  final UserModel otherUser;
  final bool isFollowing;

  LoadedState({
    @required this.otherUser,
    @required this.isFollowing,
  });

  @override
  List<Object> get props => [
        otherUser,
        isFollowing,
      ];
}

class ErrorState extends OtherProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
