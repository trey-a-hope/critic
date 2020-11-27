import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

//State: Initial view, nothing has been changed.
class LoginStartState extends LoginState {
  LoginStartState();

  @override
  List<Object> get props => [];
}

class LoadingState extends LoginState {}

class ErrorState extends LoginState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
