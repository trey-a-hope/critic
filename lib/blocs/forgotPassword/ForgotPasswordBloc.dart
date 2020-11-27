import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/AuthService.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart';

abstract class ForgotPasswordDelegate {
  void showMessage({@required String message});
}

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(null);

  ForgotPasswordDelegate _forgotPasswordDelegate;

  void setDelegate({@required ForgotPasswordDelegate delegate}) {
    this._forgotPasswordDelegate = delegate;
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        yield LoadedState();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitEvent) {
      yield LoadingState();

      try {
        final String email = event.email;

        locator<AuthService>().resetPassword(email: email);

        _forgotPasswordDelegate.showMessage(message: 'Email sent.');
        yield LoadedState();
      } catch (error) {
        _forgotPasswordDelegate.showMessage(
          message: error.toString(),
        );
        yield LoadedState();
      }
    }
  }
}
