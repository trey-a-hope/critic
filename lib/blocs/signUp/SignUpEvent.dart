import 'package:critic/blocs/signUp/Bloc.dart';
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

class NavigateToTermsServicePageEvent extends SignUpEvent {
  List<Object> get props => [];
}

class TermsServiceCheckboxEvent extends SignUpEvent {
  final bool checked;
  final GlobalKey<FormState> formKey;

  TermsServiceCheckboxEvent({
    @required this.checked,
    @required this.formKey,
  });

  List<Object> get props => [
        checked,
        formKey,
      ];
}
