part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final bool passwordVisible;

  LoginInitial({
    @required this.passwordVisible,
  });

  @override
  List<Object> get props => [
        passwordVisible,
      ];
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final dynamic error;

  LoginError({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
