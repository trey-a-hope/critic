import 'package:bloc/bloc.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/signUp/SignUpEvent.dart';
import 'package:critic/blocs/signUp/SignUpState.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FCMNotificationService.dart';
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
      try {
        yield LoadingState();

        final String email = event.email;
        final String password = event.password;
        final String username = event.username;

        final UserCredential userCredential = await locator<AuthService>()
            .createUserWithEmailAndPassword(email: email, password: password);

        final User firebaseUser = userCredential.user;

        UserModel newUser = UserModel(
          imgUrl: DUMMY_PROFILE_PHOTO_URL,
          email: email,
          created: DateTime.now(),
          modified: DateTime.now(),
          uid: firebaseUser.uid,
          username: username,
          critiqueCount: 0,
          fcmToken: null,
        );

        await locator<UserService>().createUser(user: newUser);

        final UserModel treyHopeUser =
            await locator<UserService>().retrieveUser(uid: TREY_HOPE_UID);

        //Follow Trey Hope.
        await locator<CritiqueService>()
            .followUser(myUID: newUser.uid, theirUID: treyHopeUser.uid);
        await locator<CritiqueService>()
            .followUser(myUID: treyHopeUser.uid, theirUID: newUser.uid);

        await locator<FCMNotificationService>().sendNotificationToUser(
          fcmToken: treyHopeUser.fcmToken,
          title: 'New Follower',
          body: newUser.username,
          notificationData: null,
        );

        _signUpBlocDelegate.navigateHome();

        yield SignUpStartState(termsServicesChecked: _termsServicesChecked);
      } catch (error) {
        _signUpBlocDelegate.showMessage(message: 'Error: ${error.toString()}');
        yield SignUpStartState(termsServicesChecked: _termsServicesChecked);
      }
    }

    if (event is NavigateToTermsServicePageEvent) {
      _signUpBlocDelegate.navigateToTermsServicePage();
    }

    if (event is TermsServiceCheckboxEvent) {
      _termsServicesChecked = event.checked;

      yield SignUpStartState(
        termsServicesChecked: _termsServicesChecked,
      );
    }
  }
}
