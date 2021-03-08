import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/FollowStatsModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/widgets/CritiqueView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:critic/blocs/followers/Bloc.dart' as FOLLOWERS_BP;
import 'package:critic/blocs/followings/Bloc.dart' as FOLLOWINGS_BP;
import 'package:pagination/pagination.dart';
import '../../ServiceLocator.dart';
import '../../Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_page.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(LoadingState());

  UserModel currentUser;

  int limit = 25;

  DocumentSnapshot startAfterDocument;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadPageEvent) {
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
        yield ErrorState(error: error);
      }
    }
  }
}
