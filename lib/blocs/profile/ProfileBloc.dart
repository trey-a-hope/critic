import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FollowerService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  }
}
