import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpStartState extends SignUpState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  SignUpStartState({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}

class LoadingState extends SignUpState {}
