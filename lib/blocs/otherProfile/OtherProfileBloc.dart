import 'package:bloc/bloc.dart';
import 'package:critic/blocs/followings/Bloc.dart' as FOLLOWINGS_BP;
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/FollowerService.dart';
import 'package:critic/services/UserService.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class OtherProfileBlocDelegate {
  void navigateHome();
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
  bool _isFollowing;

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

        _isFollowing = await locator<FollowerService>()
            .followerAisFollowingUserB(
                userAID: _currentUser.uid, userBID: _otherUser.uid);

        yield LoadedState(otherUser: _otherUser, isFollowing: _isFollowing);
      } catch (error) {
        _otherProfileBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');

        yield LoadedState(otherUser: _otherUser, isFollowing: _isFollowing);
      }
    }

    if (event is FollowEvent) {
      //todo delete this, it's not needed.
      if (_otherUser.uid == _currentUser.uid) {
        _otherProfileBlocDelegate.showMessage(
          message: 'Sorry, you can\'t follow yourself.',
        );
        return;
      }

      locator<FollowerService>().follow(
        followed: _otherUser.uid,
        follower: _currentUser.uid,
      );

      yield LoadedState(otherUser: _otherUser, isFollowing: true);
    }

    if (event is UnfollowEvent) {
      locator<FollowerService>().unfollow(
        followed: _otherUser.uid,
        follower: _currentUser.uid,
      );

      yield LoadedState(otherUser: _otherUser, isFollowing: false);
    }

    if (event is BlockUserEvent) {
      locator<FollowerService>().unfollow(
        followed: _otherUser.uid,
        follower: _currentUser.uid,
      );

      locator<FollowerService>().unfollow(
        followed: _currentUser.uid,
        follower: _otherUser.uid,
      );

      locator<FollowerService>().block(
        blockerID: _currentUser.uid,
        blockeeID: _otherUser.uid,
      );

      _otherProfileBlocDelegate.navigateHome();
    }
  }
}
