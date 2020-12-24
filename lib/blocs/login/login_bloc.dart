import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/signUp/Bloc.dart' as SIGN_UP_BP;
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/forgotPassword/Bloc.dart' as FORGOT_PASSWORD_BP;

part 'login_event.dart';
part 'login_state.dart';
part 'login_page.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      try {
        yield LoginLoading();

        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        yield LoginInitial();
      } catch (error) {
        yield LoginError(error: error);
      }
    }

    if (event is TryAgain) {
      yield LoginInitial();
    }
  }
}
