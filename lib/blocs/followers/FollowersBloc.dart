import 'package:bloc/bloc.dart';
import 'package:critic/blocs/followers/FollowersEvent.dart';
import 'package:critic/blocs/followers/FollowersState.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';

abstract class FollowersBlocDelegate {
  void showMessage({@required String message});
}

class FollowersBloc extends Bloc<FollowersEvent, FollowersState> {
  FollowersBloc({
    @required this.user,
  }) : super(null);

  FollowersBlocDelegate _followersBlocDelegate;
  final UserModel user;
  int limit = 10;

  void setDelegate({@required FollowersBlocDelegate delegate}) {
    this._followersBlocDelegate = delegate;
  }

  @override
  Stream<FollowersState> mapEventToState(FollowersEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        yield LoadedState();
      } catch (error) {
        _followersBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }
  }
}
