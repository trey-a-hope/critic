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
          LoginStartState(
            autoValidate: false,
            formKey: GlobalKey<FormState>(),
          ),
        );

  LoginBlocDelegate _loginBlocDelegate;

  void setDelegate({@required LoginBlocDelegate delegate}) {
    this._loginBlocDelegate = delegate;
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is Login) {
      if (event.formKey.currentState.validate()) {
        yield LoadingState();
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: event.email, password: event.password);

          yield LoginStartState(autoValidate: true, formKey: event.formKey);
        } catch (error) {
          _loginBlocDelegate.showMessage(message: 'Error: ${error.toString()}');
          yield LoginStartState(autoValidate: true, formKey: event.formKey);
        }
      }
    }
  }
}
