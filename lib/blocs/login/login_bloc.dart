import 'dart:async';
import 'package:critic/widgets/full_width_button.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/constants.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'dart:io' show Platform;

part 'login_event.dart';

part 'login_state.dart';

part 'login_page.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc()
      : super(
          LoginInitialState(),
        );

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GoogleSignInEvent) {
      try {
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // If user cancels selection, throw error to prevent null check below.
        if (googleUser == null) {
          throw Exception('Must select a Google Account.');
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      } catch (error) {
        yield LoginErrorState(error: error);
      }
    }

    if (event is AppleSignInEvent) {
      try {
        // Trigger the authentication flow.
        final AuthorizationCredentialAppleID appleIdCredential =
            await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        // Created credential from id credential.
        final OAuthCredential credential =
            OAuthProvider('apple.com').credential(
          idToken: appleIdCredential.identityToken!,
          accessToken: appleIdCredential.authorizationCode,
        );

        // Once signed in, return the UserCredential.
        await _auth.signInWithCredential(credential);
      } catch (error) {
        yield LoginErrorState(error: error);
      }
    }

    if (event is TryAgain) {
      // Send user back to login page.
      yield LoginInitialState();
    }
  }
}
