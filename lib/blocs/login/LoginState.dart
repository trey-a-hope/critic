import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

//State: Initial view, nothing has been changed.
class LoginStartState extends LoginState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  LoginStartState({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}

//State: View of the user when loogging in.
class LoadingState extends LoginState {}
