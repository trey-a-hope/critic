import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/FollowerService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'package:bloc/bloc.dart';
import 'AllUsersEvent.dart';
import 'AllUsersState.dart';

abstract class AllUsersBlocDelegate {
  void showMessage({@required String message});
}

class AllUsersBloc extends Bloc<AllUsersEvent, AllUsersState> {
  AllUsersBloc() : super(null);
  AllUsersBlocDelegate _allUsersBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required AllUsersBlocDelegate delegate}) {
    this._allUsersBlocDelegate = delegate;
  }

  @override
  Stream<AllUsersState> mapEventToState(AllUsersEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        List<UserModel> allUsers =
            await locator<UserService>().retrieveAllUsers();

        yield LoadedState(users: allUsers);
      } catch (error) {
        _allUsersBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }
  }
}
