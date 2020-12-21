import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/UserService.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';
part 'edit_profile_view.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  UserModel _currentUser;

  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {
    if (event is LoadPage) {
      yield EditProfileLoading();

      _currentUser = await locator<AuthService>().getCurrentUser();

      // _editProfileBlocDelegate.setTextFields(user: _currentUser);

      yield EditProfileLoaded(
        currentUser: _currentUser,
      );
    }

    if (event is Save) {
      yield EditProfileLoading();
      try {
        final String username = event.username;

        await locator<UserService>().updateUser(
          uid: _currentUser.uid,
          data: {
            'username': username,
            'modified': DateTime.now(),
          },
        );

        _currentUser.username = username;

        //_editProfileBlocDelegate.showMessage(message: 'Profile updated.');

        yield EditProfileLoaded(
          currentUser: _currentUser,
        );
      } catch (error) {
        yield ErrorState(error: error);
        // _editProfileBlocDelegate.showMessage(
        //     message: 'Error: ${error.toString()}');

        // yield EditProfileStartState(
        //   currentUser: _currentUser,
        // );
      }
    }
  }
}
