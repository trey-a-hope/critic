import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FollowersState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends FollowersState {}

class NoFollowersState extends FollowersState {
  NoFollowersState();

  @override
  List<Object> get props => [];
}

class FoundFollowersState extends FollowersState {
  final List<UserModel> users;
  FoundFollowersState({
    @required this.users,
  });

  @override
  List<Object> get props => [users];
}
