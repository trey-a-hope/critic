import 'package:bloc/bloc.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:flutter/material.dart';

import 'Bloc.dart';

abstract class LikesBlocDelegate {
  void showMessage({@required String message});
}

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  LikesBloc({
    @required this.critique,
  }) : super(null);

  final CritiqueModel critique;

  LikesBlocDelegate _likesBlocDelegate;

  UserModel _currentUser;

  List<UserModel> _likeUsers = List<UserModel>();

  void setDelegate({@required LikesBlocDelegate delegate}) {
    this._likesBlocDelegate = delegate;
  }

  @override
  Stream<LikesState> mapEventToState(LikesEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _likeUsers = await locator<CritiqueService>()
            .retrieveLikeUsers(critiqueID: critique.id);

        yield LoadedState(
          likeUsers: _likeUsers,
        );
      } catch (error) {
        _likesBlocDelegate.showMessage(
          message: 'Error: ${error.toString()}',
        );
      }
    }
  }
}
