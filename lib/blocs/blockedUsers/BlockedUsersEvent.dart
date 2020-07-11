import 'package:critic/blocs/editProfile/Bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BlockedUsersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends BlockedUsersEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class UnblockUserEvent extends BlockedUsersEvent {
  final String userID;
  UnblockUserEvent({
    @required this.userID,
  });

  List<Object> get props => [userID];
}
