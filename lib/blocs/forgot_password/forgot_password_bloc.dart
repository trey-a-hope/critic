import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/widgets/full_width_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/services.dart';
import '../../Constants.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';
part 'forgot_password_page.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(null);

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        yield LoadedState(showMessage: false);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitEvent) {
      yield LoadingState();

      try {
        final String email = event.email;

        locator<AuthService>().resetPassword(email: email);

        yield LoadedState(showMessage: true, message: 'Email sent.');
      } catch (error) {
        yield LoadedState(showMessage: true, message: error.toString());
      }
    }
  }
}
