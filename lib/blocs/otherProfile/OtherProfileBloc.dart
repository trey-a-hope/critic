import 'package:bloc/bloc.dart';
import 'package:critic/blocs/otherProfile/OtherProfileEvent.dart';
import 'package:critic/blocs/otherProfile/OtherProfileState.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/UserService.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class OtherProfileBlocDelegate {
  void showMessage({@required String message});
}

class OtherProfileBloc extends Bloc<OtherProfileEvent, OtherProfileState> {
  OtherProfileBloc({
    @required this.otherUserID,
  }) : super(null);

  final String otherUserID;
  UserModel _otherUser;
  UserModel _currentUser;
  OtherProfileBlocDelegate _otherProfileBlocDelegate;

  void setDelegate({@required OtherProfileBlocDelegate delegate}) {
    this._otherProfileBlocDelegate = delegate;
  }

  @override
  Stream<OtherProfileState> mapEventToState(OtherProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _otherUser =
            await locator<UserService>().retrieveUser(uid: otherUserID);

        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState(otherUser: _otherUser, isFollowing: false);
      } catch (error) {
        _otherProfileBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');

        yield LoadedState(otherUser: _otherUser, isFollowing: false);
      }
    }

    if (event is FollowEvent) {
      if (_otherUser.uid == _currentUser.uid) {
        _otherProfileBlocDelegate.showMessage(
          message: 'Sorry, you can\'t follow yourself.',
        );
        return;
      }

      //todo: follow user.
      yield LoadedState(otherUser: _otherUser, isFollowing: true);
    }

    if (event is UnfollowEvent) {
      //todo: unfollow user.
      yield LoadedState(otherUser: _otherUser, isFollowing: false);
    }
  }
}
