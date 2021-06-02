part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ForgotPasswordState {}

class LoadedState extends ForgotPasswordState {
  final bool showMessage;
  final String message;

  LoadedState({
    @required this.showMessage,
    this.message,
  });

  @override
  List<Object> get props => [
        showMessage,
        message,
      ];
}

class ErrorState extends ForgotPasswordState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
