import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SearchUsersState extends Equatable {
  const SearchUsersState();

  @override
  List<Object> get props => [];
}

class SearchUsersStateEmpty extends SearchUsersState {}

class SearchUsersStateLoading extends SearchUsersState {}

class SearchUsersStateSuccess extends SearchUsersState {
  final List<UserModel> users;

  const SearchUsersStateSuccess({
    @required this.users,
  });

  @override
  List<Object> get props => [users];

  @override
  String toString() => 'SearchUsersStateSuccess { items: ${users.length} }';
}

class SearchUsersStateError extends SearchUsersState {
  final dynamic error;

  const SearchUsersStateError({
    @required this.error,
  });

  @override
  List<Object> get props => [error];
}
