import 'package:bloc/bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';


abstract class ProfileBlocDelegate {
  void showMessage({@required String message});
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(null);

  ProfileBlocDelegate _profileBlocDelegate;

  UserModel currentUser;

  List<String> _followersIDs;

  List<String> _followingsIDs;

  int limit = 10;

  DocumentSnapshot startAfterDocument;

  void setDelegate({@required ProfileBlocDelegate delegate}) {
    this._profileBlocDelegate = delegate;
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        currentUser = await locator<AuthService>().getCurrentUser();

        _followersIDs = [];

        _followingsIDs = [];

        startAfterDocument = null;

        yield LoadedState(
          currentUser: currentUser,
          followers: _followersIDs,
          followings: _followingsIDs,
        );
      } catch (error) {
        _profileBlocDelegate.showMessage(message: error.toString());
        yield ErrorState(error: error);
      }
    }

    if (event is UploadImageEvent) {
      try {
        PickedFile file =
            await ImagePicker().getImage(source: event.imageSource);

        if (file == null) return;

        File image = await ImageCropper.cropImage(sourcePath: file.path);

        if (image == null) return;

        yield LoadingState();

        //loadingText = 'Saving image...';

        //Start loading indicator.
        // setState(() {
        //   isLoading = true;
        // });

        //Update image variables.
        //profileImage = image;

        //Get image upload url.
        final String newImgUrl = await locator<StorageService>().uploadImage(
            file: image, imgPath: 'Images/Users/${currentUser.uid}/Profile');

        //Save image upload url.
        await locator<UserService>()
            .updateUser(uid: currentUser.uid, data: {'imgUrl': newImgUrl});

        // //Update image url on user.
        // currentUser.imgUrl = newImgUrl;

        // //Update loading text, probably don't need it here again...
        // loadingText = null;

        // //Stop loading indicator.
        // setState(() {
        //   isLoading = false;
        // });

        add(LoadPageEvent());
      } catch (error) {
        _profileBlocDelegate.showMessage(
          message: error.toString(),
        );
      }
    }
  }
}
