//import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

//State: Initial view, nothing has been changed.
class LoginNotStarted extends LoginState {}

//State: View of the user when loogging in.
class LoggingIn extends LoginState {}

//State: View of a successful login.
class LoginSuccessful extends LoginState {
  final AuthResult authResult;

  LoginSuccessful({
    @required this.authResult,
  });

  @override
  List<Object> get props => [authResult];
}

//State: View of an unsuccessful login.
class LoginFailed extends LoginState {
  final dynamic error;

  LoginFailed({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
