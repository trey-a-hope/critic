import 'package:bloc/bloc.dart';
import 'package:critic/login/LoginRepo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//EVENTS
class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//Event: User selects login.
class Login extends LoginEvent {
  final String email;
  final String password;

  Login({@required this.email, @required this.password});

  List<Object> get props => [email, password];
}

//STATES
class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

//State: Initial view, nothing has been changed.
class LoginNotStarted extends LoginState {}

//State: View of the user when loogging in.
class LoggingIn extends LoginState {}

//State: View of a successful login.
class LoginSuccessful extends LoginState {
  final AuthResult authResult;

  LoginSuccessful({
    @required this.authResult,
  });

  @override
  List<Object> get props => [authResult];
}

//State: View of an unsuccessful login.
class LoginFailed extends LoginState {
  final dynamic error;

  LoginFailed({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepo loginRepo;

  LoginBloc({@required this.loginRepo});

  @override
  LoginState get initialState => LoginNotStarted();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is Login) {
      yield LoggingIn();
      try {
        AuthResult authResult = await loginRepo.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        yield LoginSuccessful(authResult: authResult);
      } catch (error) {
        yield LoginFailed(error: error);
      }
    }
  }
}
