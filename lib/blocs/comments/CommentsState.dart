import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CommentsState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends CommentsState {}

class LoadedState extends CommentsState {
  final UserModel currentUser;

  LoadedState({
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        currentUser,
      ];
}
