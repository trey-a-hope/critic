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

part 'login_event.dart';
part 'login_state.dart';
part 'login_page.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial(passwordVisible: false));

  bool _passwordVisible = false;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      try {
        yield LoginLoading();

        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        yield LoginInitial(passwordVisible: _passwordVisible);
      } catch (error) {
        yield LoginError(error: error);
      }
    }

    if (event is TryAgain) {
      yield LoginInitial(passwordVisible: _passwordVisible);
    }

    if (event is UpdatePasswordVisibleEvent) {
      _passwordVisible = !_passwordVisible;
      yield LoginInitial(passwordVisible: _passwordVisible);
    }
  }
}
