import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FollowerService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class HomeBlocDelegate {
  void showMessage({@required String message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(
          HomeState(),
        );

  HomeBlocDelegate _homeBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required HomeBlocDelegate delegate}) {
    this._homeBlocDelegate = delegate;
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        List<CritiqueModel> critiques =
            await locator<CritiqueService>().retrieveCritiquesFromStream(
          uid: _currentUser.uid,
          limit: 100,
          offset: 0,
        );

        if (critiques.isEmpty) {
          yield NoCritiquesState();
        } else {
          yield FoundCritiquesState(
            critiques: critiques,
            currentUser: _currentUser,
          );
        }
      } catch (error) {
        _homeBlocDelegate.showMessage(message: 'Error: ${error.toString()}');
        yield ErrorState(error: error);
      }
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
