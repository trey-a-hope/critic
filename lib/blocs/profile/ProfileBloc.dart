import 'package:bloc/bloc.dart';
import 'package:critic/models/FollowStatsModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
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

        startAfterDocument = null;

        FollowStatsModel followStatsModel =
            await locator<CritiqueService>().followStats(uid: currentUser.uid);

        yield LoadedState(
          currentUser: currentUser,
          followerCount: followStatsModel.followers,
          followingCount: followStatsModel.followees,
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

        final String newImgUrl = await locator<StorageService>().uploadImage(
            file: image, imgPath: 'Images/Users/${currentUser.uid}/Profile');

        await locator<UserService>()
            .updateUser(uid: currentUser.uid, data: {'imgUrl': newImgUrl});

        add(LoadPageEvent());
      } catch (error) {
        _profileBlocDelegate.showMessage(
          message: error.toString(),
        );
      }
    }
  }
}
