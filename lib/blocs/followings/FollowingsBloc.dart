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
    @required this.user,
  }) : super(null);

  FollowingsBlocDelegate _followingsBlocDelegate;
  final UserModel user;
  int limit = 10;

  void setDelegate({@required FollowingsBlocDelegate delegate}) {
    this._followingsBlocDelegate = delegate;
  }

  @override
  Stream<FollowingsState> mapEventToState(FollowingsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        yield LoadedState();
      } catch (error) {
        _followingsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }
  }
}
