part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ForgotPasswordState {}

class LoadedState extends ForgotPasswordState {}

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
