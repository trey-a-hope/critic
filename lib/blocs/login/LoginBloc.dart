import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc();

  @override
  LoginState get initialState => LoginNotStarted();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    //Event, user attempts login.
    if (event is Login) {
      //Display loading screen initially...
      yield LoggingIn();
      try {
        //Proceed to login via service.
        AuthResult authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: event.email, password: event.password);
        //Continue to success screen.
        yield LoginSuccessful(authResult: authResult);
      } catch (error) {
        //Display the error that happened.
        yield LoginFailed(error: error);
      }
    }
  }
}
