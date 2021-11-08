part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  final bool passwordVisible;
  final bool rememberMe;
  LoginInitial({
    required this.passwordVisible,
    required this.rememberMe,
  });

  @override
  List<Object> get props => [
        passwordVisible,
        rememberMe,
      ];
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final dynamic error;

  LoginError({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
