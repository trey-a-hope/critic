import 'package:bloc/bloc.dart';
import 'package:critic/models/FollowStatsModel.dart';
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

  UserModel currentUser;

  UserModel otherUser;

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

        yield LoadedState(
          otherUser: otherUser,
        );
      } catch (error) {
        _otherProfileBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');

        yield LoadedState(
          otherUser: otherUser,
        );
      }
    }
  }
}
