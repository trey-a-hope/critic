import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/initialize_dependencies.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/storage_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/util_service.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:critic/widgets/critique_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination_view/pagination_view.dart';
import '../../constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/blocs/create_critique/create_critique_bloc.dart'
    as CREATE_CRITIQUE_BP;

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_page.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(LoadingState());

  late UserModel currentUser;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadPageEvent) {
      try {
        currentUser = await locator<AuthService>().getCurrentUser();

        // List<MovieModel> movies = await locator<UserService>()
        //     .listMoviesFromWatchList(uid: currentUser.uid);

        yield LoadedState(
          currentUser: currentUser,
          movies: [],
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is UploadImageEvent) {
      try {
        XFile? file = await ImagePicker().pickImage(source: event.imageSource);

        if (file == null) return;

        File? image = await ImageCropper.cropImage(sourcePath: file.path);

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
