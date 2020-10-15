import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AllUsersState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends AllUsersState {}

class LoadedState extends AllUsersState {
  final List<UserModel> users;
  final UserModel currentUser;

  LoadedState({
    @required this.users,
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        users,
        currentUser,
      ];
}
