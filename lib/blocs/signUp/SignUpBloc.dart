import 'package:bloc/bloc.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/signUp/SignUpEvent.dart';
import 'package:critic/blocs/signUp/SignUpState.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constants.dart';

abstract class SignUpBlocDelegate {
  void navigateHome();
  void navigateToTermsServicePage();
  void showMessage({@required String message});
}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc()
      : super(
          SignUpStartState(
            autoValidate: false,
            formKey: GlobalKey<FormState>(),
            termsServicesChecked: false,
          ),
        );

  SignUpBlocDelegate _signUpBlocDelegate;
  bool _termsServicesChecked = false;

  void setDelegate({@required SignUpBlocDelegate delegate}) {
    this._signUpBlocDelegate = delegate;
  }

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUp) {
      if (event.formKey.currentState.validate()) {
        yield LoadingState();
        try {
          final String email = event.email;
          final String password = event.password;
          final String username = event.username;

          UserCredential userCredential = await locator<AuthService>()
              .createUserWithEmailAndPassword(email: email, password: password);

          final User firebaseUser = userCredential.user;

          UserModel user = UserModel(
            imgUrl: DUMMY_PROFILE_PHOTO_URL,
            email: email,
            created: DateTime.now(),
            modified: DateTime.now(),
            uid: firebaseUser.uid,
            username: username,
            critiqueCount: 0,
          );

          await locator<UserService>().createUser(user: user);

          _signUpBlocDelegate.navigateHome();

          yield SignUpStartState(
              autoValidate: true,
              formKey: event.formKey,
              termsServicesChecked: _termsServicesChecked);
        } catch (error) {
          _signUpBlocDelegate.showMessage(
              message: 'Error: ${error.toString()}');
          yield SignUpStartState(
              autoValidate: true,
              formKey: event.formKey,
              termsServicesChecked: _termsServicesChecked);
        }
      }
    }

    if (event is NavigateToTermsServicePageEvent) {
      _signUpBlocDelegate.navigateToTermsServicePage();
    }

    if (event is TermsServiceCheckboxEvent) {
      _termsServicesChecked = event.checked;

      yield SignUpStartState(
          autoValidate: true,
          formKey: event.formKey,
          termsServicesChecked: _termsServicesChecked);
    }
  }
}
