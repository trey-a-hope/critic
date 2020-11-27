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
  final int followerCount;
  final int followingCount;

  LoadedState({
    @required this.otherUser,
    @required this.isFollowing,
    @required this.followerCount,
    @required this.followingCount,
  });

  @override
  List<Object> get props => [
        otherUser,
        isFollowing,
        followerCount,
        followingCount,
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
