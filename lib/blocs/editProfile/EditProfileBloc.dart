import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:image_picker/image_picker.dart';

abstract class EditProfileBlocDelegate {
  void showMessage({
    @required String message,
  });
  void setTextFields({
    @required UserModel user,
  });
}

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(null);

  EditProfileBlocDelegate _editProfileBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required EditProfileBlocDelegate delegate}) {
    this._editProfileBlocDelegate = delegate;
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      _currentUser = await locator<AuthService>().getCurrentUser();

      _editProfileBlocDelegate.setTextFields(user: _currentUser);

      yield EditProfileStartState(
        currentUser: _currentUser,
      );
    }

    if (event is UploadPictureEvent) {
      final File image = event.image;

      try {
        final String imgUrl = await locator<StorageService>().uploadImage(
          file: image,
          imgPath: 'Images/Users/${_currentUser.uid}/Profile',
        );

        await locator<UserService>().updateUser(
          uid: _currentUser.uid,
          data: {
            'imgUrl': imgUrl,
          },
        );

        add(LoadPageEvent());
      } catch (error) {
        _editProfileBlocDelegate.showMessage(
          message: error.toString(),
        );
      }
    }

    if (event is SaveFormEvent) {
      yield LoadingState();
      try {
        final String username = event.username;

        _editProfileBlocDelegate.showMessage(message: 'Updating...');

        await locator<UserService>().updateUser(
          uid: _currentUser.uid,
          data: {
            'username': username,
            'modified': DateTime.now(),
          },
        );

        _currentUser.username = username;

        _editProfileBlocDelegate.showMessage(message: 'Updated!...');

        yield EditProfileStartState(
          currentUser: _currentUser,
        );
      } catch (error) {
        _editProfileBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');

        yield EditProfileStartState(
          currentUser: _currentUser,
        );
      }
    }
  }
}
