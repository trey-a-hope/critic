import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FollowingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends FollowingsState {}

class NoFollowingsState extends FollowingsState {
  NoFollowingsState();

  @override
  List<Object> get props => [];
}

class FoundFollowingsState extends FollowingsState {
  final List<UserModel> users;
  FoundFollowingsState({
    @required this.users,
  });

  @override
  List<Object> get props => [users];
}
