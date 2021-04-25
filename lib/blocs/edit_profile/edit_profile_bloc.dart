import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/models/user_Model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/widgets/full_width_button.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

        yield EditProfileLoaded(
          currentUser: _currentUser,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
