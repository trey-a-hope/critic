part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends ForgotPasswordEvent {
  LoadPageEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends ForgotPasswordEvent {
  final String email;

  SubmitEvent({
    required this.email,
  });

  @override
  List<Object> get props => [
        email,
      ];
}
