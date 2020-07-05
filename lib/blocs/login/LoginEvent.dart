import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {
  final String email;
  final String password;
  final GlobalKey<FormState> formKey;

  Login({
    @required this.email,
    @required this.password,
    @required this.formKey,
  });

  List<Object> get props => [
        email,
        password,
        formKey,
      ];
}
