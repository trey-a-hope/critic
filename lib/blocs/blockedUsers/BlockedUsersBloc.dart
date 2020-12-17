import 'package:critic/blocs/blockedUsers/Bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/BlockUserService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'package:bloc/bloc.dart';

abstract class BlockedUsersBlocDelegate {
  void showMessage({@required String message});
}

class BlockedUsersBloc extends Bloc<BlockedUsersEvent, BlockedUsersState> {
  BlockedUsersBloc() : super(null);
  BlockedUsersBlocDelegate _blockedUsersBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required BlockedUsersBlocDelegate delegate}) {
    this._blockedUsersBlocDelegate = delegate;
  }

  @override
  Stream<BlockedUsersState> mapEventToState(BlockedUsersEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        final List<String> blockedUsersIDs = await locator<BlockUserService>()
            .getUsersIBlockedIDs(userID: _currentUser.uid);
        List<UserModel> users = [];

        for (var i = 0; i < blockedUsersIDs.length; i++) {
          UserModel user = await locator<UserService>()
              .retrieveUser(uid: blockedUsersIDs[i]);
          users.add(user);
        }

        users.add(_currentUser);

        if (users.isEmpty) {
          yield NoBlockedUsersState();
        } else {
          yield FoundBlockUsersState(users: users);
        }
      } catch (error) {
        _blockedUsersBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is UnblockUserEvent) {
      locator<BlockUserService>().unblock(
        blockerID: _currentUser.uid,
        blockeeID: event.userID,
      );

      _blockedUsersBlocDelegate.showMessage(
          message: 'User has been unblocked, close this page.');
    }
  }
}
