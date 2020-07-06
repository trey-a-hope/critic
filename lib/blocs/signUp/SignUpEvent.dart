import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUp extends SignUpEvent {
  final String username;
  final String email;
  final String password;
  final GlobalKey<FormState> formKey;

  SignUp({
    @required this.username,
    @required this.email,
    @required this.password,
    @required this.formKey,
  });

  List<Object> get props => [
        username,
        email,
        password,
        formKey,
      ];
}
