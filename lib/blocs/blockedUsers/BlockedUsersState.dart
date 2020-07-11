import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BlockedUsersState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends BlockedUsersState {}

class NoBlockedUsersState extends BlockedUsersState {
  NoBlockedUsersState();

  @override
  List<Object> get props => [];
}

class FoundBlockUsersState extends BlockedUsersState {
  final List<UserModel> users;
  FoundBlockUsersState({
    @required this.users,
  });

  @override
  List<Object> get props => [users];
}
