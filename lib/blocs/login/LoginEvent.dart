import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {
  final String email;
  final String password;

  Login({
    @required this.email,
    @required this.password,
  });

  List<Object> get props => [
        email,
        password,
      ];
}
