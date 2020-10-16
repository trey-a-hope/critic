import 'package:bloc/bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/BlockUserService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FCMNotificationService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class OtherProfileBlocDelegate {
  void navigateHome();
  void showMessage({@required String message});
}

class OtherProfileBloc extends Bloc<OtherProfileEvent, OtherProfileState> {
  OtherProfileBloc({
    @required this.otherUserID,
  }) : super(null);

  final String otherUserID;

  OtherProfileBlocDelegate _otherProfileBlocDelegate;

  bool _isFollowing = false;

  UserModel currentUser;

  UserModel otherUser;

  int limit = 10;

  DocumentSnapshot startAfterDocument;

  void setDelegate({@required OtherProfileBlocDelegate delegate}) {
    this._otherProfileBlocDelegate = delegate;
  }

  @override
  Stream<OtherProfileState> mapEventToState(OtherProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        otherUser = await locator<UserService>().retrieveUser(uid: otherUserID);

        currentUser = await locator<AuthService>().getCurrentUser();

        _isFollowing = await locator<CritiqueService>().isFollowing(
          myUID: currentUser.uid,
          theirUID: otherUser.uid,
        );

        startAfterDocument = null;

        // _isFollowing = await locator<FollowerService>()
        //     .followerAisFollowingUserB(
        //         userAID: _currentUser.uid, userBID: _otherUser.uid);

        yield LoadedState(otherUser: otherUser, isFollowing: _isFollowing);
      } catch (error) {
        _otherProfileBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');

        yield LoadedState(otherUser: otherUser, isFollowing: _isFollowing);
      }
    }

    if (event is FollowEvent) {
      yield LoadingState();
      try {
        await locator<CritiqueService>()
            .followUser(myUID: currentUser.uid, theirUID: otherUser.uid);

        _isFollowing = await locator<CritiqueService>().isFollowing(
          myUID: currentUser.uid,
          theirUID: otherUser.uid,
        );

        if (_isFollowing && otherUser.fcmToken != null) {
          //Send notification to user.
          await locator<FCMNotificationService>().sendNotificationToUser(
            fcmToken: otherUser.fcmToken,
            title: 'You gained a new follower!',
            body: '${currentUser.username}',
            notificationData: null,
          );
        }

        add(LoadPageEvent());
      } catch (error) {
        yield ErrorState(error: error.toString());
      }
    }

    if (event is UnfollowEvent) {
      yield LoadingState();
      try {
        await locator<CritiqueService>()
            .unfollowUser(myUID: currentUser.uid, theirUID: otherUser.uid);

        _isFollowing = await locator<CritiqueService>().isFollowing(
          myUID: currentUser.uid,
          theirUID: otherUser.uid,
        );

        add(LoadPageEvent());
      } catch (error) {
        yield ErrorState(error: error.toString());
      }
    }

    if (event is BlockUserEvent) {
      if (otherUser.uid == currentUser.uid) {
        _otherProfileBlocDelegate.showMessage(
          message: 'Sorry, you can\'t block yourself.',
        );
        return;
      }

      await locator<CritiqueService>().unfollowUser(
        myUID: currentUser.uid,
        theirUID: otherUser.uid,
      );

      await locator<CritiqueService>().unfollowUser(
        myUID: otherUser.uid,
        theirUID: currentUser.uid,
      );

      locator<BlockUserService>().block(
        blockerID: currentUser.uid,
        blockeeID: otherUser.uid,
      );

      _otherProfileBlocDelegate.navigateHome();
    }
  }
}
