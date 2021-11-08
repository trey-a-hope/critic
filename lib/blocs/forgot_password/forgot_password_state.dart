part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object?> get props => [];
}

class InitialState extends ForgotPasswordState {}

class LoadingState extends ForgotPasswordState {}

class LoadedState extends ForgotPasswordState {
  final bool showMessage;
  final String? message;

  LoadedState({
    required this.showMessage,
    required this.message,
  });

  @override
  List<Object?> get props => [
        showMessage,
        message,
      ];
}

class ErrorState extends ForgotPasswordState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
