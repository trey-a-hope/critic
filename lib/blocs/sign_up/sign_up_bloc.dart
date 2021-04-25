import 'package:bloc/bloc.dart';
import 'package:critic/models/user_Model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/fcm_notification_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/widgets/full_width_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/Constants.dart';
import 'package:critic/pages/terms_service_view.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants.dart';

part 'sign_up_event.dart';
part 'sign_up_page.dart';
part 'sign_up_state.dart';

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
          watchListCount: 0,
        );

        await locator<UserService>().createUser(user: newUser);

        final UserModel treyHopeUser =
            await locator<UserService>().retrieveUser(uid: TREY_HOPE_UID);

        await locator<FCMNotificationService>().sendNotificationToUser(
          fcmToken: treyHopeUser.fcmToken,
          title: 'New User!',
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
