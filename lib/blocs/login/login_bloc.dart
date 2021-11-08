import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/widgets/full_width_button.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/Constants.dart';
import 'package:critic/blocs/sign_up/sign_up_bloc.dart' as SIGN_UP_BP;
import 'package:critic/widgets/Spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/forgot_password/forgot_password_bloc.dart'
    as FORGOT_PASSWORD_BP;
import 'package:hive/hive.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_page.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static Box<dynamic> _loginCredentialsBox =
      Hive.box<String>(HIVE_BOX_LOGIN_CREDENTIALS);

  LoginBloc()
      : super(
          LoginInitial(
            passwordVisible: false,
            rememberMe: _loginCredentialsBox.get('email') != null,
          ),
        );

  bool _passwordVisible = false;
  bool _rememberMe = _loginCredentialsBox.get('email') != null;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      final String email = event.email;
      final String password = event.password;

      try {
        yield LoginLoading();

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        //Save users email and password if remember me box checked.
        if (_rememberMe) {
          _loginCredentialsBox.put('email', email);
          _loginCredentialsBox.put('password', password);
        } else {
          _loginCredentialsBox.clear();
        }

        yield LoginInitial(
            passwordVisible: _passwordVisible, rememberMe: _rememberMe);
      } catch (error) {
        yield LoginError(error: error);
      }
    }

    if (event is TryAgain) {
      yield LoginInitial(
          passwordVisible: _passwordVisible, rememberMe: _rememberMe);
    }

    if (event is UpdatePasswordVisibleEvent) {
      _passwordVisible = !_passwordVisible;
      yield LoginInitial(
          passwordVisible: _passwordVisible, rememberMe: _rememberMe);
    }

    if (event is UpdateRememberMeEvent) {
      _rememberMe = !_rememberMe;
      yield LoginInitial(
          passwordVisible: _passwordVisible, rememberMe: _rememberMe);
    }
  }
}
