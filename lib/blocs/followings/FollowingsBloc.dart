import 'package:bloc/bloc.dart';
import 'package:critic/blocs/followings/Bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';

abstract class FollowingsBlocDelegate {
  void showMessage({@required String message});
}

class FollowingsBloc extends Bloc<FollowingsEvent, FollowingsState> {
  FollowingsBloc({
    @required this.followingsIDs,
  }) : super(null);
  final List<String> followingsIDs;
  FollowingsBlocDelegate _followingsBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required FollowingsBlocDelegate delegate}) {
    this._followingsBlocDelegate = delegate;
  }

  @override
  Stream<FollowingsState> mapEventToState(FollowingsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        List<UserModel> users = List<UserModel>();

        for (var i = 0; i < followingsIDs.length; i++) {
          UserModel user =
              await locator<UserService>().retrieveUser(uid: followingsIDs[i]);
          users.add(user);
        }

        if (users.isEmpty) {
          yield NoFollowingsState();
        } else {
          yield FoundFollowingsState(users: users);
        }
      } catch (error) {
        _followingsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }
  }
}
