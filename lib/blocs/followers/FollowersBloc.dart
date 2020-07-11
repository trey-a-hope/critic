import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:critic/blocs/followers/FollowersEvent.dart';
import 'package:critic/blocs/followers/FollowersState.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';

abstract class FollowersBlocDelegate {
  void showMessage({@required String message});
}

class FollowersBloc extends Bloc<FollowersEvent, FollowersState> {
  FollowersBloc({
    @required this.followersIDs,
  }) : super(null);
  final List<String> followersIDs;
  FollowersBlocDelegate _followersBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required FollowersBlocDelegate delegate}) {
    this._followersBlocDelegate = delegate;
  }

  @override
  Stream<FollowersState> mapEventToState(FollowersEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        List<UserModel> users = List<UserModel>();

        for (var i = 0; i < followersIDs.length; i++) {
          UserModel user =
              await locator<UserService>().retrieveUser(uid: followersIDs[i]);
          users.add(user);
        }

        if (users.isEmpty) {
          yield NoFollowersState();
        } else {
          yield FoundFollowersState(users: users);
        }
      } catch (error) {
        _followersBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }
  }
}
