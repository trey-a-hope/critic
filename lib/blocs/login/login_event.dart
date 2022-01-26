part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class Login extends LoginEvent {
  final String email;
  final String password;

  Login({
    required this.email,
    required this.password,
  });

  List<Object> get props => [
        email,
        password,
      ];
}

class GoogleLoginEvent extends LoginEvent {}

class TryAgain extends LoginEvent {}

class UpdatePasswordVisibleEvent extends LoginEvent {}

class UpdateRememberMeEvent extends LoginEvent {}
