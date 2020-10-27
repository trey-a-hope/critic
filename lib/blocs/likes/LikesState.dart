import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LikesState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends LikesState {}

class LoadedState extends LikesState {
  final List<UserModel> likeUsers;

  LoadedState({
    @required this.likeUsers,
  });

  @override
  List<Object> get props => [];
}
