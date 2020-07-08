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
  void showMessage({@required String message});
}

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(null);

  EditProfileBlocDelegate _editProfileBlocDelegate;
  UserModel _currentUser;
  File _profilePic;
  ImageProvider _profilePicImageProvider;

  void setDelegate({@required EditProfileBlocDelegate delegate}) {
    this._editProfileBlocDelegate = delegate;
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      _currentUser = await locator<AuthService>().getCurrentUser();

      _profilePicImageProvider = NetworkImage(_currentUser.imgUrl);

      yield EditProfileStartState(
          currentUser: _currentUser,
          autoValidate: false,
          formKey: GlobalKey<FormState>(),
          profilePicImageProvider: _profilePicImageProvider);
    }

    if (event is PickProfileImageEvent) {
      final File image =
          await ImagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      _profilePicImageProvider = FileImage(image);
      _profilePic = image;

      yield EditProfileStartState(
          currentUser: _currentUser,
          autoValidate: false,
          formKey: GlobalKey<FormState>(),
          profilePicImageProvider: _profilePicImageProvider);
    }

    if (event is SaveFormEvent) {
      if (event.formKey.currentState.validate()) {
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

          if (_profilePic != null) {
            final String newImgUrl =
                await locator<StorageService>().uploadImage(
              file: _profilePic,
              imgPath: 'Images/Users/${_currentUser.uid}/Profile',
            );

            await locator<UserService>().updateUser(
              uid: _currentUser.uid,
              data: {'imgUrl': newImgUrl},
            );
          }

          _editProfileBlocDelegate.showMessage(message: 'Updated!...');

          yield EditProfileStartState(
              currentUser: _currentUser,
              autoValidate: true,
              formKey: event.formKey,
              profilePicImageProvider: _profilePicImageProvider);
        } catch (error) {
          _editProfileBlocDelegate.showMessage(
              message: 'Error: ${error.toString()}');

          yield EditProfileStartState(
              currentUser: _currentUser,
              autoValidate: true,
              formKey: event.formKey,
              profilePicImageProvider: _profilePicImageProvider);
        }
      }
    }
  }
}
