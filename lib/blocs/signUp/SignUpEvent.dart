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

  SignUp({
    @required this.username,
    @required this.email,
    @required this.password,
  });

  List<Object> get props => [
        username,
        email,
        password,
      ];
}

class NavigateToTermsServicePageEvent extends SignUpEvent {
  List<Object> get props => [];
}

class TermsServiceCheckboxEvent extends SignUpEvent {
  final bool checked;

  TermsServiceCheckboxEvent({
    @required this.checked,
  });

  List<Object> get props => [
        checked,
      ];
}
