import 'dart:async';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/initialize_dependencies.dart';
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

  late UserModel _currentUser;

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

        //Update the user.
        await locator<UserService>().updateUser(
          uid: _currentUser.uid!,
          data: {
            'username': username,
            'modified': DateTime.now(),
          },
        );

        //Fetch the updated user.
        _currentUser =
            await locator<UserService>().retrieveUser(uid: _currentUser.uid!);

        yield EditProfileLoaded(
          currentUser: _currentUser,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
