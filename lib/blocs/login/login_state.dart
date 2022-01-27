part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {
  LoginInitialState();

  @override
  List<Object> get props => [];
}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final dynamic error;

  LoginErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
