import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Bloc.dart';

abstract class LoginBlocDelegate {
  void navigateHome();
  void showMessage({@required String message});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(
          LoginStartState(),
        );

  LoginBlocDelegate _loginBlocDelegate;

  void setDelegate({@required LoginBlocDelegate delegate}) {
    this._loginBlocDelegate = delegate;
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is Login) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        yield LoginStartState();
      } catch (error) {
        _loginBlocDelegate.showMessage(message: 'Error: ${error.toString()}');
        yield LoginStartState();
      }
    }
  }
}
